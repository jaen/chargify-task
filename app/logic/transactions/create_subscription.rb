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
    step   :build,   :with => Operations::BuildSubscriptionModel
    tee    :persist!

    private

    def validate(params)
      Validators::CreateSubscription.new(params).validate
    end

    def build(params)
      super(params[:subscription].except(:billing_details))
    end

    def persist!(subscription)
      subscription.save!
      subscription.reload
    end
  end
end
