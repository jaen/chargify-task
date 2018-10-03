require "rails_helper"

def nest(path)
  path.reverse.reduce { |acc, key| {key => acc} }
end

module Validators
  RSpec.describe CreateSubscription, :type => :validator do
    it "is valid with with all attributes properly specified" do
      params = build(:create_subscription_params)

      result = CreateSubscription.new(params).validate

      expect(result).to be_success
    end

    def expect_validated(override, errors:)
      params = build(:create_subscription_params, nest(override[1..-1]))

      result = CreateSubscription.new(params.compact).validate

      path_to_check = override[0..-2].map do |element|
        element.to_s.gsub(/_attributes$/, "").to_sym
      end

      expect(result).to be_failure
      expect(result.failure.dig(*path_to_check)).to eq(errors)
    end

    VALIDATIONS = {
      [:subscription, :shipping_address_details_attributes, :name, nil]                 => ["must be filled", "size cannot be less than 1"],
      [:subscription, :shipping_address_details_attributes, :address, nil]              => ["must be filled", "size cannot be less than 1"],
      [:subscription, :shipping_address_details_attributes, :country, "NOTISO"]         => ["is invalid"],
      [:subscription, :shipping_address_details_attributes, :country, nil]              => ["must be filled", "is invalid"],
      [:subscription, :shipping_address_details_attributes, :zip_code, nil]             => ["must be filled", "size cannot be less than 1"],

      [:payment, :billing_details_attributes, :card_number, nil]                   => ["must be filled"],
      [:payment, :billing_details_attributes, :security_code, nil]                 => ["must be filled"],
      [:payment, :billing_details_attributes, :expiration_month, nil]              => ["must be filled"],
      [:payment, :billing_details_attributes, :expiration_year, nil]               => ["must be filled"],
      [:payment, :billing_details_attributes, :zip_code, nil]                      => ["must be filled"],

      [:subscription, :subscription_level_id, nil]                                      => ["must be filled", "is invalid"],
      [:subscription, :subscription_level_id, SubscriptionLevel.last.id + 1]            => ["is invalid"]
    }

    VALIDATIONS.each do |override, errors|
      it "is invalid when attribute #{nest(override[0..-2])} is not properly specified" do
        expect_validated(override, :errors => errors)
      end
    end

    it "is invalid when no billing method attribute is properly specified" do
      params = build(:create_subscription_params)
      params[:payment].delete(:billing_details)

      result = CreateSubscription.new(params).validate

      expect(result).to be_failure
      expect(result.failure.dig(:payment, :billing_details).uniq).to eq(["must be filled"])
      expect(result.failure.dig(:payment, :card_details_id).uniq).to eq(["must be filled"])
    end

    it "is invalid when more than one billing method attribute is properly specified" do
      params = build(:create_subscription_params)
      card_details = create(:card_details)
      params[:payment][:card_details_id] = card_details.id

      result = CreateSubscription.new(params).validate

      expect(result).to be_failure
      expect(result.failure.dig(:payment, :billing_details).uniq).to eq(["must be filled"])
      expect(result.failure.dig(:payment, :card_details_id).uniq).to eq(["must be filled"])
    end
  end
end
