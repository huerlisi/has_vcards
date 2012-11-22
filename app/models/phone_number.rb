class PhoneNumber < ActiveRecord::Base
  # Access restrictions
  attr_accessible :phone_number_type, :number

  # Vcard association
  belongs_to :vcard, :inverse_of => :contacts
  belongs_to :object, :polymorphic => true

  # Validation
  validates_presence_of :number

  # phone number types
  scope :by_type, lambda {|value| where(:phone_number_type => value)}
  scope :phone, by_type('phone')
  scope :fax, by_type('fax')
  scope :mobile, by_type('mobile')
  scope :email, by_type('email')

  def label
    case phone_number_type
    when 'phone'
      "Tel:"
    when 'fax'
      "Fax:"
    when 'mobile'
      "Mob:"
    when 'email'
      "Mail:"
    else
      phone_number_type
    end
  end
  
  # String
  def to_s(separator = " ", format = :default)
    case format
      when :label
        return [label, number].compact.join(separator)
      else
        return number
    end
  end
end
