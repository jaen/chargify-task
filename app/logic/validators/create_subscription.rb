module Validators
  ##
  # A validator for shipping details.
  #
  class ShippingDetails < Base
    validations do
      required(:name).filled(:min_size? => 1)
      required(:address).filled(:min_size? => 1)
      required(:country).filled(:country?)
      required(:zip_code).filled(:min_size? => 1)
    end
  end

  ##
  # A validator for billing details.
  #
  class BillingDetails < Base
    validations do
      required(:card_number).filled(:str?)
      required(:security_code).filled(:str?)
      required(:expiration_month).filled(:int?)
      required(:expiration_year).filled(:int?)
      required(:zip_code).filled(:str?)
    end
  end

  ##
  # A validator for parameters required to create a subscription.
  #
  class CreateSubscription < Base
    validations do
      required(:subscription).schema do
        required(:shipping_address_details).schema(ShippingDetails)
        required(:billing_details).schema(BillingDetails)
        required(:subscription_level_id).filled(:associated? => SubscriptionLevel)
      end
    end
  end
end
