# Phone Number / Contact model
#
# This model holds a contact for a Vcard. It is called PhoneNumber in
# compliance with the vCard spec, but can hold any kind of contact like mobile
# phone, email, or homepage.
#
# There can be multiple phone numbers be assigned to a vcard, where they are
# available as the #contacts association.
#
# The #label method uses the I18n locales to translate the phone_number_type.
# You may add additional ones in under the
# 'activerecord.attributes.has_vcards/phone_number.phone_number_type_enum'
# scope.
module HasVcards
  class PhoneNumber < ActiveRecord::Base
    # Access restrictions
    attr_accessible :phone_number_type, :number if defined?(ActiveModel::MassAssignmentSecurity)

    # Vcard association
    belongs_to :vcard, inverse_of: :contacts

    # Validation
    validates_presence_of :number

    # phone number types
    scope :by_type, ->(value) { where(phone_number_type: value) }
    scope :phone, by_type('phone')
    scope :fax, by_type('fax')
    scope :mobile, by_type('mobile')
    scope :email, by_type('email')

    def label
      I18n.translate(phone_number_type, scope: 'activerecord.attributes.has_vcards/phone_number.phone_number_type_enum', default: phone_number_type.titleize)
    end

    # String
    def to_s(format = :default, separator = ': ')
      case format
      when :label
        return [label, number].compact.join(separator)
      else
        return number
      end
    end

    # Generate a contact URL
    def to_url
      scheme = case phone_number_type
        when 'phone'  then 'tel'
        when 'mobile' then 'tel'
        when 'fax'    then 'fax'
        when 'email'  then 'mailto'
      end

      if scheme
        "#{scheme}:#{number}"
      end
    end
  end
end
