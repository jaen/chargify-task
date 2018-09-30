FactoryBot.define do
  ##
  # Creates a hash of billing details parameters.
  #
  factory :billing_details_parameters, :class => Hash do
    skip_create

    card_number      { Faker::Business.credit_card_number }
    security_code    { Faker::Stripe.ccv }
    expiration_month { Faker::Date.forward.month }
    expiration_year  { Faker::Date.forward.year }
    zip_code         { Faker::Address.zip_code }

    initialize_with { attributes }
  end
end
