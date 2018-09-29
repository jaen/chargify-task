FactoryBot.define do
  factory :card_details do
    customer
    card_token { Faker::Crypto.md5 }
  end
end
