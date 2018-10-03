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
    # @param [Subscription]
    #   subscription subscription to bill.
    #
    # @param [Hash]
    #   billing_details details of card to bill.
    #
    def call(subscription, billing_details:)
      begin
        response = fake_pay_client.purchase!(
          FakePay::CardDetailsPurchaseRequest.new(
            :amount => subscription.subscription_level.price,
            **billing_details))

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
