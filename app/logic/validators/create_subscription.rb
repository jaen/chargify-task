module Validators
  ##
  # A validator for shipping details.
  #
  class ShippingAddressDetails < Base
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
  # Of note is the fact that it requires either of +:billing_details+ or +:card_details_id+ to
  # be filled for billing, but not both at the same time.
  #
  class CreateSubscription < Base
    validations do
      required(:subscription).schema do
        required(:shipping_address_details).schema(ShippingAddressDetails)
        required(:subscription_level_id).filled(:associated? => SubscriptionLevel)
      end

      required(:payment).schema do
        optional(:billing_details).schema(BillingDetails)
        optional(:card_details_id).filled(:associated? => CardDetails)

        rule(:payment => {:card_details_id => [:billing_details, :card_details_id]}) do |billing_details, card_details_id|
          value(:billing_details).filled? ^ value(:card_details_id).filled?
        end

        rule(:payment => {:billing_details => [:billing_details, :card_details_id]}) do |billing_details, card_details_id|
          value(:billing_details).filled? ^ value(:card_details_id).filled?
        end
      end
    end
  end
end
