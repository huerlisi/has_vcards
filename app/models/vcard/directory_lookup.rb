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

  def directory_match?(ignore_lookup_fields = [], ignore_match_fields = nil)
    # Match all fields we search for, by default
    ignore_match_fields ||= ignore_lookup_fields

    matches = directory_lookup(ignore_lookup_fields)
    matches.select do |match|
      search = map_for_directory
      # Only match fields not in ignore list
      search.reject!{|key, value| ignore_match_fields.include? key}
      changes = search.reject do |key, value|
        UnicodeUtils.downcase(match.send(key).to_s) == UnicodeUtils.downcase(value.to_s)
      end

      changes.empty?
    end.present?
  end
end
