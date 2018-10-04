require "fake_pay/client"
require "dry/transaction/operation"

module Transactions
  ##
  # A transaction accepting parameters that pass {Validator::CreateSubscription}[rdoc-ref:Validator::CreateSubscription]
  # validator and returns an instance of the {Subscription}[rdoc-ref:Subscription] database model. A job to charge for
  # the subscription is ran asynchronously.
  #
  class CreateSubscription < Base
    attr_accessor :payment_params

    step   :validate
    step   :get_subscription_params
    step   :build,                  :with => Operations::BuildSubscriptionModel

    around :in_transaction!,        :with => Operations::TransactionWrapper
    tee    :persist!
    step   :charge!,                :with => Operations::ChargeSubscription

    private

    def validate(params)
      Validators::CreateSubscription.new(params).validate
    end

    ##
    # Splits the subscription-related parameters from billing-related parameters and stores the latter
    # in a field for use in charging the subscription further down the line.
    #
    # @param [Hash] params transaction input parameters.
    #
    def get_subscription_params(params)
      subscription_params = params[:subscription]
      self.payment_params = params[:payment]
      Success(subscription_params)
    end

    def persist!(subscription)
      subscription.save!
      subscription.reload
    end

    def charge!(subscription)
      result = super(subscription, **self.payment_params)

      map_fake_pay_failure(result)
    end

    ##
    # Map FakePay client errors to a format matching the API response format.
    #
    def map_fake_pay_failure(result)
      if result.failure?
        case result.failure
          when FakePay::Errors::InvalidCreditCardNumber;  Failure({:payment => {:billing_details => {:card_number => ["is invalid"]}}})
          when FakePay::Errors::InvalidZipCode;           Failure({:payment => {:billing_details => {:zip_code => ["is invalid"]}}})
          when FakePay::Errors::InsufficientFunds;        Failure({:payment => {:billing_details => {:card_number => ["has insufficient funds"]}}})
          when FakePay::Errors::SecurityCodeCheckFailure; Failure({:payment => {:billing_details => {:security_code => ["is invalid"]}}})
          when FakePay::Errors::ExpiredCard;              Failure({:payment => {:billing_details => {:expirationMonth => ["is expired"], :expirationYear => ["is expired"]}}})
        end
      else
        result
      end
    end
  end
end
