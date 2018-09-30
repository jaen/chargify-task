require "pry"

FactoryBot.define do
  ##
  # Creates a hash of parameters required to create a subscription from the API.
  #
  factory :create_subscription_params, :class => Hash do
    skip_create

    transient do
      shipping_address_details_attributes { nil }
      billing_details_attributes { nil }
    end

    shipping_address_details { attributes_for(:shipping_address_details, shipping_address_details_attributes) }
    billing_details          { attributes_for(:billing_details_parameters, billing_details_attributes) }
    subscription_level_id    { SubscriptionLevel.pluck(:id).sample }

    initialize_with { {:subscription => attributes} }
  end
end
