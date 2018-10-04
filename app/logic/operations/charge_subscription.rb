require "fake_pay/client"
require "dry/transaction/operation"

module Operations
  ##
  # An operation charging a subscription.
  #
  class ChargeSubscription
    include Dry::Transaction::Operation

    ##
    # Executes the operation.
    #
    # @param [Subscription] subscription
    #  subscription to bill.
    #
    # @param [Hash] billing_details
    #   details of card to bill.
    #
    # @param [Hash] card_details_id
    #   an id a {CardDetails}[rdoc-ref:CardDetails]} database model storing a token
    #   of card to bill.
    #
    def call(subscription, billing_details: nil, card_details_id: nil)
      unless billing_details.present? ^ card_details_id.present?
        raise ArgumentError.new("Either :billing_details or :card_details_id has to be specified")
      end

      begin
        request = if billing_details
          FakePay::CardDetailsPurchaseRequest.new(
            :amount => subscription.subscription_level.price,
            **billing_details)
        else
          card_details = CardDetails.find(card_details_id)

          FakePay::CardTokenPurchaseRequest.new(
            :amount     => subscription.subscription_level.price,
            :card_token => card_details.card_token)
        end

        response = fake_pay_client.purchase!(request)

        card_details = CardDetails.new(
          :card_token => response.card_token,
          :customer   => subscription.customer)

        subscription_payment = SubscriptionPayment.new(
          :status       => :success,
          :valid_to     => DateTime.now + subscription.subscription_level.billing_period,
          :subscription => subscription,
          :card_details => card_details)

        subscription_payment.save!

        Success(subscription)
      rescue FakePay::Errors::FakePayError => e
        subscription_payment = SubscriptionPayment.new(
          :status       => :failure,
          :subscription => subscription,
          :error        => e.class.to_s)

        subscription_payment.save!

        Failure(e)
      end
    end

    ##
    # Provides a memoised FakePay client.
    #
    private def fake_pay_client
      @fake_pay_client ||= FakePay::Client.new(:api_token => Rails.application.secrets.fake_pay_key)
    end
  end
end
