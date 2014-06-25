module HasVcards
  class Vcard
    module DirectoryAddress
      def to_vcard
        Vcard.new(
          given_name: first_name,
          family_name: family_name,
          street_address: street,
          postal_code: zip_code,
          locality: city
        )
      end

      def to_vcard_attributes
        {
          given_name: first_name,
          family_name: family_name,
          street_address: street,
          postal_code: zip_code,
          locality: city
        }
      end
    end
  end
end
