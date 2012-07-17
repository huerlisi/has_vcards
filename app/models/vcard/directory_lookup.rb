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

  def directory_match?(ignore_fields = [])
    directory_lookup(ignore_fields).present?
  end

  module ClassMethods
  end
end
