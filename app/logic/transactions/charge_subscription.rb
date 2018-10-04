require "fake_pay/client"
require "dry/transaction/operation"

module Transactions
  ##
  # A transaction accepting a {Subscription}[Subscription] and a +:card_details_id+ parameter on the
  # +:charge!+ step and charges the subscription.
  #
  class ChargeSubscription < Base
    step :charge!, :with => Operations::ChargeSubscription
  end
end
