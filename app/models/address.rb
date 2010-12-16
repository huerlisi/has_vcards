class Address < ActiveRecord::Base
  belongs_to :vcard
  
  # Helpers
  def to_s
    I18n.translate('has_vcards.address.to_s',
      :street_address => street_address,
      :postal_code => postal_code,
      :locality => locality
    )
  end
end
