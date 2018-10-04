require "rails_helper"

module Transactions
  RSpec.describe CreateSubscription, :vcr, :type => :logic do
    it "responds with errors when no data is specified" do
      params = {}
      result = CreateSubscription.new.run!(params)

      expect(result).to be_failure
      expect(result.failure.dig(:subscription)).to eq ["is missing"]
    end

    it "returns a invalid card number error when 4242424242424241 card is specified" do
      params = build(:create_subscription_params, :billing_details_attributes => {:card_number => "4242424242424241"})
      result = CreateSubscription.new.run!(params)

      expect(result).to be_failure
      expect(result.failure.dig(:payment, :billing_details, :card_number)).to eq(["is invalid"])
    end

    it "returns an insufficient funds error when 4242424242420089 card is specified" do
      params = build(:create_subscription_params, :billing_details_attributes => {:card_number => "4242424242420089"})
      result = CreateSubscription.new.run!(params)

      expect(result).to be_failure
      expect(result.failure.dig(:payment, :billing_details, :card_number)).to eq(["has insufficient funds"])
    end

    it "returns an invalid security code error when wrong security code is specified is specified" do
      params = build(:create_subscription_params, :billing_details_attributes => {:security_code => "1337"})
      result = CreateSubscription.new.run!(params)

      expect(result).to be_failure
      expect(result.failure.dig(:payment, :billing_details, :security_code)).to eq(["is invalid"])
    end

    it "returns a subscription when all the data is specified" do
      params = build(:create_subscription_params)
      result = CreateSubscription.new.run!(params)

      expect(result).to be_success
      expect(result.success).to be_instance_of Subscription
    end

    it "returns a subscription when using an existing customer and all the data is specified" do
      existing_subscription = CreateSubscription.new.run!(build(:create_subscription_params)).success
      customer = existing_subscription.customer

      params = build(:create_subscription_params)
      params[:subscription].delete(:shipping_address_details)
      params[:subscription][:customer_id] = customer.id

      result = CreateSubscription.new.run!(params)

      expect(result).to be_success
      expect(result.success).to be_instance_of Subscription
    end

    it "returns a subscription when using an existing customer and and an existing card and all the data is specified" do
      existing_subscription = CreateSubscription.new.run!(build(:create_subscription_params)).success
      customer = existing_subscription.customer
      card_details = customer.card_details.first

      params = build(:create_subscription_params)
      params[:subscription].delete(:shipping_address_details)
      params[:subscription][:customer_id] = customer.id
      params[:payment].delete(:billing_details)
      params[:payment][:card_details_id] = card_details.id

      result = CreateSubscription.new.run!(params)

      expect(result).to be_success
      expect(result.success).to be_instance_of Subscription
    end
  end
end
