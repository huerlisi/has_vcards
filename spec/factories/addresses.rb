FactoryGirl.define do
  factory :address, class: HasVcards::Address do
    sequence(:postal_code) { |n| "8200#{ n }" }
    locality 'Test Town'
    street_address '312 Test Street'
  end
end
