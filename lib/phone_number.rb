class PhoneNumber < ActiveRecord::Base
  belongs_to :vcard, :class_name => 'Vcards::Vcard'
  belongs_to :object, :polymorphic => true

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
