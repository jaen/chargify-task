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
    # @param [Hash] shipping_address_details
    #   describing shipping address for subscription (see {Validators::ShippingAddressDetails}[rdoc-ref:Validators::ShippingAddressDetails]).
    #
    # @param [Integer] subscription_level_id
    #   id of a {SubscriptionLevel}[rdoc-ref:SubscriptionLevel] this subscription is for.
    #
    def call(shipping_address_details:, subscription_level_id:)
      customer = Customer.new

      shipping_address_details = ShippingAddressDetails.new(
        **shipping_address_details,
        :customer => customer)

      subscription_level = SubscriptionLevel.find(subscription_level_id)

      subscription = Subscription.new(
        :customer                 => customer,
        :subscription_level       => subscription_level,
        :shipping_address_details => shipping_address_details)

      Success(subscription)
    end
  end
end
