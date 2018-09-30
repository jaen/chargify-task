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
      params = build(:create_subscription_params, nest(override))

      result = CreateSubscription.new(params.compact).validate

      expect(result).to be_failure
      expect(result.failure.dig(:subscription, *override[0..-2])).to eq(errors)
    end

    VALIDATIONS = {
      [:shipping_address_details, :name, nil]                 => ["must be filled", "size cannot be less than 1"],
      [:shipping_address_details, :address, nil]              => ["must be filled", "size cannot be less than 1"],
      [:shipping_address_details, :country, "NOTISO"]         => ["is invalid"],
      [:shipping_address_details, :country, nil]              => ["must be filled", "is invalid"],
      [:shipping_address_details, :zip_code, nil]             => ["must be filled", "size cannot be less than 1"],

      [:billing_details, :card_number, nil]                   => ["must be filled"],
      [:billing_details, :security_code, nil]                 => ["must be filled"],
      [:billing_details, :expiration_month, nil]              => ["must be filled"],
      [:billing_details, :expiration_year, nil]               => ["must be filled"],
      [:billing_details, :zip_code, nil]                      => ["must be filled"],

      [:subscription_level_id, nil]                           => ["must be filled", "is invalid"],
      [:subscription_level_id, SubscriptionLevel.last.id + 1] => ["is invalid"]
    }

    VALIDATIONS.each do |override, errors|
      it "is invalid when attribute #{nest(override[0..-2])} is not properly specified" do
        expect_validated(override, :errors => errors)
      end
    end
  end
end
