FactoryBot.define do
  factory :shipping_address_details do
    customer
    name     { Faker::Name.name }
    address  { Faker::Address.full_address }
    country  { Faker::Address.country_code }
    zip_code { Faker::Address.zip_code }
  end
end
