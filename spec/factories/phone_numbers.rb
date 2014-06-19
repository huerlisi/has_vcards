FactoryGirl.define do
  factory :phone_number, class: HasVcards::PhoneNumber do
    sequence(:number) { |n| "+41 000-111-#{ n }" }
    vcard
    phone_number_type 'phone'
  end
end
