require "rails_helper"

module Transactions
  RSpec.describe CreateSubscription, :type => :logic do
    it "responds with errors when no data is specified" do
      params = {}
      result = CreateSubscription.new.run!(params)

      expect(result).to be_failure
      expect(result.failure.dig(:subscription)).to eq ["is missing"]
    end

    it "returns a subscription when all the data is specified" do
      params = build(:create_subscription_params)
      result = CreateSubscription.new.run!(params)

      expect(result).to be_success
      expect(result.success).to be_instance_of Subscription
    end
  end
end
