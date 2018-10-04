require "fake_pay/client"
require "dry/transaction/operation"

module Operations
  ##
  # An operation that builds a {Subscription}[rdoc-ref:Subscription] database model from a hash of parameters.
  #
  class BuildSubscriptionModel
    include Dry::Transaction::Operation

    ##
    # Executes the operation.
    #
    # @param [Integer] subscription_level_id
    #   id of a {SubscriptionLevel}[rdoc-ref:SubscriptionLevel] this subscription is for.
    #
    # @param [Integer] customer_id
    #   an optional reference to a {Customer}{rdoc-ref:Customer} database model to associate
    #   the subscription to. Otherwise a new customer will be created.
    #
    # @param [Hash] shipping_address_details
    #   describing shipping address for subscription (see {Validators::ShippingAddressDetails}[rdoc-ref:Validators::ShippingAddressDetails]).
    #
    def call(subscription_level_id:, customer_id: nil, shipping_address_details: nil)
      unless customer_id.present? ^ shipping_address_details.present?
        raise ArgumentError.new("Either :customer_id or :shipping_address_details has to be specified")
      end

      customer = if customer_id
        Customer.find(customer_id)
      else
        Customer.new
      end

      shipping_address_details = if customer_id
        customer.shipping_address_details.last
      else
        ShippingAddressDetails.new(
          **shipping_address_details,
          :customer => customer)
      end

      subscription_level = SubscriptionLevel.find(subscription_level_id)

      subscription = Subscription.new(
        :customer                 => customer,
        :subscription_level       => subscription_level,
        :shipping_address_details => shipping_address_details)

      Success(subscription)
    end
  end
end
