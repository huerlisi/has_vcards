module Vcard::DirectoryLookup
  def map_for_directory
    search = {}
    search[:first_name] = given_name
    search[:family_name] = family_name
    search[:street] = street_address
    search[:zip_code] = postal_code
    search[:city] = locality

    search
  end

  def directory_lookup(ignore_fields = [])
    search = map_for_directory

    search.reject!{|key, value| ignore_fields.include? key}

    # TODO:
    # We should fetch additional pages if the result indicates there
    # are more pages.
    ::SwissMatch.directory_service.addresses(search, :per_page => 100)
  end

  def directory_found?(ignore_fields = [])
    directory_lookup(ignore_fields).present?
  end

  def normalize(value)
    normalized_value = UnicodeUtils.downcase(value.to_s)
    normalized_value.gsub!(/str\./, 'strasse')
    normalized_value.gsub!(/str([ $])/, 'strasse\1')

    normalized_value
  end

  def directory_matches(ignore_lookup_fields = [])
    matches = directory_lookup(ignore_lookup_fields)
    matches.map do |match|
      search = map_for_directory

      perfect = []
      search.each do |key, value|
        perfect << key if normalize(match.send(key)) == normalize(value)
      end

      partial = []
      search.each do |key, value|
        partial << key if value.present? && normalize(match.send(key)).include?(normalize(value))
      end
      partial -= perfect

      bad = search.keys - perfect - partial - ignore_lookup_fields

      {:address => match, :perfect => perfect, :partial => partial, :bad => bad, :ignore => ignore_lookup_fields}
    end
  end

  def directory_filter(match, filter = {})
    # Exact filters
    filter[:perfect].each do |field|
      return false unless match[:perfect].include?(field)
    end if filter[:perfect]
    filter[:partial].each do |field|
      return false unless match[:partial].include?(field)
    end if filter[:partial]
    filter[:bad].each do |field|
      return false unless match[:bad].include?(field)
    end if filter[:bad]

    # "Better than" filters
    filter[:partial_or_perfect].each do |field|
      return false unless match[:perfect].include?(field) || match[:partial].include?(field)
    end if filter[:partial_or_perfect]

    return true
  end

  # Everything matches
  def perfect_matches
    directory_matches.collect do |match|
      match[:address] if directory_filter(match, :perfect => [:family_name, :first_name, :street, :city])
    end.compact
  end

  def perfect_match?
    perfect_matches.present?
  end

  # Everything is found, given or family name does is partial match
  def great_matches
    directory_matches.collect do |match|
      match[:address] if directory_filter(match, :partial_or_perfect => [:family_name, :first_name], :perfect => [:street, :city])
    end.compact
  end

  def great_match?
    great_matches.present?
  end

  # Everything but given name matches, family name might be partial
  def family_name_matches
    directory_matches([:first_name]).collect do |match|
      match[:address] if directory_filter(match, :partial_or_perfect => [:family_name], :perfect => [:street, :city])
    end.compact
  end

  def family_name_match?
    family_name_matches.present?
  end

  # Same address different names
  def address_matches
    directory_matches([:first_name, :family_name]).collect do |match|
      match[:address] if directory_filter(match, :perfect => [:street, :city])
    end.compact
  end

  # Similar name in same locality
  def locality_matches
    directory_matches([:first_name, :street]).collect do |match|
      match[:address] if directory_filter(match, :partial_or_perfect => [:family_name], :perfect => [:city])
    end.compact
  end
end
