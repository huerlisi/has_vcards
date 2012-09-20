class Address < ActiveRecord::Base
  belongs_to :vcard
  
  # Validations
  include I18nHelpers

  def validate_address
    errors.add_on_blank(:postal_code)
    errors.add_on_blank(:locality)

    if street_address.blank? and extended_address.blank? and post_office_box.blank?
      errors.add(:street_address, "#{t_attr(:street_address, Vcard)} #{I18n.translate('errors.messages.empty')}")
      errors.add(:extended_address, "#{t_attr(:extended_address, Vcard)} #{I18n.translate('errors.messages.empty')}")
      errors.add(:post_office_box, "#{t_attr(:post_office_box, Vcard)} #{I18n.translate('errors.messages.empty')}")
    end
  end

  # Helpers
  def to_s
    I18n.translate('has_vcards.address.to_s',
      :street_address => street_address,
      :postal_code => postal_code,
      :locality => locality
    )
  end

  # Composed attributes
  def zip_locality
    "#{postal_code} #{locality}"
  end

  def zip_locality=(value)
    self.postal_code, self.locality = value.split(' ', 2)
  end
end
