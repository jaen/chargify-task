require "rails_helper"

require "fake_pay/client"

module FakePay
  RSpec.describe Client do
    let(:client) { Client.new(:api_token => Rails.application.secrets.fake_pay_key) }

    def card_details_request(**overrides)
      CardDetailsPurchaseRequest.new(
        :amount           => Money.new("1000", :usd),
        :card_number      => "4242424242424242",
        :security_code    => "123",
        :expiration_month => 1,
        :expiration_year  => 2024,
        :zip_code         => "10045",
        **overrides)
    end

    it "instantiates when given an API key" do
      expect(client).not_to be_nil
    end

    describe "API calls" do
      it "allows to make a purchase request with card details" do
        response = client.purchase!(card_details_request)

        expect(response).to                be_instance_of(PurchaseResponse)
        expect(response.card_token).not_to be_empty
      end

      it "allows to make a purchase request with a card token" do
        response = client.purchase!(card_details_request)

        expect(response).to                be_instance_of(PurchaseResponse)
        expect(response.card_token).not_to be_empty

        token_response = client.purchase!(CardTokenPurchaseRequest.new(
                                            :amount     => Money.new("1000", :usd),
                                            :card_token => response.card_token))

        expect(response).to            be_instance_of(PurchaseResponse)
        expect(response.card_token).to equal(response.card_token)
      end
    end

    describe "error handling" do
      it "raises an error when the card number is invalid" do
        expect do
          client.purchase!(card_details_request(:card_number => "4242424242424241"))
        end
          .to raise_error(Errors::InvalidPurchaseRequest, "Invalid credit card number")
      end

      it "raises an error when the purchase amount is invalid" do
        expect do
          client.purchase!(card_details_request(:amount => Money.new(0, :usd)))
        end
          .to raise_error(Errors::InvalidPurchaseRequest, "Invalid purchase amount")
      end

      it "raises an error when the card token is invalid" do
        expect do
          client
          client.purchase!(CardTokenPurchaseRequest.new(
                             :amount     => Money.new("1000", :usd),
                             :card_token => "invalid"))
        end
          .to raise_error(Errors::InvalidCardToken, "Invalid card token")
      end

      it "raises an error when the security code is invalid" do
        expect do
          client.purchase!(card_details_request(:security_code => "42"))
        end
          .to raise_error(Errors::TransactionDenied, "Security code check failure")
      end

      it "raises an error when the card has insufficient funds" do
        expect do
          client.purchase!(card_details_request(:card_number => "4242424242420089"))
        end
          .to raise_error(Errors::TransactionDenied, "Insufficient funds")
      end

      it "raises an error when the card has expired" do
        expect do
          client.purchase!(card_details_request(:expiration_year => 1337))
        end
          .to raise_error(Errors::TransactionDenied, "Expired card")
      end
    end
  end
end
