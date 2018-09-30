require "rails_helper"

module Transactions
  RSpec.describe CreateSubscription, :type => :logic do
    it "responds with errors when no data is specified" do
      params = {}
      result = CreateSubscription.new.run!(params)

      expect(result).to be_failure
      expect(result.failure.dig(:subscription)).to eq ["is missing"]
    end

    it "responds with dummy response when all the data is specified" do
      params = build(:create_subscription_params)
      result = CreateSubscription.new.run!(params)

      expect(result).to be_success
      expect(result.success.dig(:subscription, :dummy)).to be true
    end
  end
end
