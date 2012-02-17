class PhoneNumber < ActiveRecord::Base
  belongs_to :vcard
  belongs_to :object, :polymorphic => true

  # phone number types
  named_scope :by_type, lambda {|value| {:conditions => {:phone_number_type => value}} }
  def self.phone
    by_type('phone')
  end
  def self.fax
    by_type('fax')
  end
  def self.mobile
    by_type('mobile')
  end
  def self.email
    by_type('email')
  end

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
