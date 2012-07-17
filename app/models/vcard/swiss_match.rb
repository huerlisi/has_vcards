module Vcard::SwissMatch
  def self.included(base)
    base.extend ClassMethods
  end

  def directory_lookup
    search = {}
    search[:first_name] = given_name
    search[:last_name] = family_name
    search[:street] = street_address
    search[:zip_code] = postal_code
    search[:city] = locality

    ::SwissMatch.directory_service.addresses(search)
  end

  def directory_match?
    directory_lookup.present?
  end

  module ClassMethods
  end
end
