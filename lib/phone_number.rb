class PhoneNumber < ActiveRecord::Base
  belongs_to :vcard
  belongs_to :object, :polymorphic => true

  validates_presence_of :number

  # phone number types
  scope :by_type, lambda {|value| where(:phone_number_type => value)}
  scope :phone, by_type('phone')
  scope :fax, by_type('fax')
  scope :mobile, by_type('mobile')
  scope :email, by_type('mobile')

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
      ""
    end
  end
  
  def to_s(separator = " ")
    return [label, number].compact.join(separator)
  end
end
