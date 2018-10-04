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
  # In +:subscription+ data either an existing {Customer}[rdoc-ref:Customer] database model can be associated
  # with the subscription by passing the +:customer_id+ parameter or a new customer can be created for a specified
  # shipping address by passing the +:shipping_address_details+ parameter. Both can't be specified at the same time.
  #
  # In +:payment` data either an existing {CardDetails}[rdoc-ref:CardDetails] database model can be associated with
  # the subscription by passing the +:card_details_id+ parameter or a new card can be charged and stored by passing
  # the +:billing_details+ parameter. Both can't be specified at the same time.
  #
  class CreateSubscription < Base
    validations do
      required(:subscription).schema do
        optional(:shipping_address_details).schema(ShippingAddressDetails)
        optional(:customer_id).filled(:associated? => Customer)
        required(:subscription_level_id).filled(:associated? => SubscriptionLevel)

        rule(:subscription => {:customer_id => [:shipping_address_details, :customer_id]}) do |shipping_address_details, customer_id|
          value(:shipping_address_details).filled? ^ value(:customer_id).filled?
        end

        rule(:subscription => {:shipping_address_details => [:shipping_address_details, :customer_id]}) do |shipping_address_details, customer_id|
          value(:shipping_address_details).filled? ^ value(:customer_id).filled?
        end
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
