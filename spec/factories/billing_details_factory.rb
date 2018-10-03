FactoryBot.define do
  ##
  # Creates a hash of billing details parameters.
  #
  factory :billing_details_parameters, :class => Hash do
    skip_create

    card_number      { Faker::Business.credit_card_number }
    security_code    { "123" }
    expiration_month { Faker::Number.between(1, 12) }
    expiration_year  { Faker::Date.between(1.year.from_now, 5.years.from_now).year }
    zip_code         { "12345" }

    initialize_with { attributes }
  end
end
