class PhoneNumber < ActiveRecord::Base
  belongs_to :vcard
  belongs_to :object, :polymorphic => true

  validates_presence_of :number

  def to_s
    case phone_number_type
    when 'phone'
      return "Tel: #{number}"
    when 'fax'
      return "Fax: #{number}"
    when 'mobile'
      return "Mob: #{number}"
    when 'email'
      return "Mail: #{number}"
    else
      return number
    end
  end
end
