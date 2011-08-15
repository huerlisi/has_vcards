class PhoneNumber < ActiveRecord::Base
  belongs_to :vcard
  belongs_to :object, :polymorphic => true

  validates_presence_of :number

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
  
  def to_s(separator = " ", format = :default)
    case format
      when :label
        return [label, number].compact.join(separator)
      else
        return number
    end
  end
end
