module Vcard::DirectoryLookup
  def map_for_directory
    search = {}
    search[:first_name] = given_name
    search[:last_name] = family_name
    search[:street] = street_address
    search[:zip_code] = postal_code
    search[:city] = locality

    search
  end

  def directory_lookup(ignore_fields = [])
    search = map_for_directory

    search.reject!{|key, value| ignore_fields.include? key}

    ::SwissMatch.directory_service.addresses(search)
  end

  def directory_found?(ignore_fields = [])
    directory_lookup(ignore_fields).present?
  end

  def directory_matches(ignore_lookup_fields = [])
    matches = directory_lookup(ignore_lookup_fields)
    matches.map do |match|
      search = map_for_directory

      perfect = []
      search.each do |key, value|
        perfect << key if UnicodeUtils.downcase(match.send(key).to_s) == UnicodeUtils.downcase(value.to_s)
      end

      partial = []
      search.each do |key, value|
        partial << key if value.present? && UnicodeUtils.downcase(match.send(key).to_s).include?(UnicodeUtils.downcase(value.to_s))
      end
      partial -= perfect

      bad = search.keys - perfect - partial

      {:address => match, :perfect => perfect, :partial => partial, :bad => bad}
    end
  end

  # Everything matches
  def perfect_matches
    directory_matches.collect do |match|
      match[:address] if match[:partial].empty? && match[:bad].empty?
    end.compact
  end

  def perfect_match?
    perfect_matches.present?
  end

  # Everything is found, given or family name does is partial match
  def great_matches
    directory_matches.collect do |match|
      next unless match[:bad].empty?

      match[:address] if match[:partial].include?(:first_name) or match[:partial].include?(:last_name)
    end.compact
  end

  def great_match?
    great_matches.present?
  end
end
