require "dry-struct"
require "money"
require "http"

module FakePay
  module Errors
    class FakePayError           < StandardError; end
    class ClientError            < FakePayError; end
    class InvalidCardToken       < FakePayError; end
    class InvalidPurchaseRequest < FakePayError; end
    class TransactionDenied      < FakePayError; end
  end

  module Types
    include Dry::Types.module
  end

  class CardDetailsPurchaseRequest < Dry::Struct
    attribute :amount,           Types.Instance(Money)
    attribute :card_number,      Types::Strict::String
    attribute :security_code,    Types::Strict::String
    attribute :expiration_month, Types::Strict::Integer
    attribute :expiration_year,  Types::Strict::Integer
    attribute :zip_code,         Types::Strict::String
  end

  class CardTokenPurchaseRequest < Dry::Struct
    attribute :amount,     Types.Instance(Money)
    attribute :card_token, Types::Strict::String
  end

  class PurchaseResponse < Dry::Struct
    attribute :card_token, Types::Strict::String
  end

  class Client
    BASE_URL = "https://www.fakepay.io"

    def initialize(api_token:)
      @base_url = BASE_URL
      @api_token = api_token
    end

    def purchase!(request)
      currency = request.amount.currency

      raise InvalidPurchaseRequest.new("Unsupported currency #{currency.iso_code}") unless currency == "USD"

      payload = request.to_hash
      payload[:amount] = payload[:amount].cents
      payload[:cvv] = payload.delete(:security_code) if payload[:security_code]
      payload[:token] = payload.delete(:card_token) if payload[:card_token]

      begin
        response = HTTP
          .auth("Token #{@api_token}")
          .accept("application/json")
          .post("#{@base_url}/purchase", :json => payload)

        response_json = response.parse.symbolize_keys

        if response_json[:success]
          PurchaseResponse.new(:card_token => response_json[:token])
        else
          case response_json[:error_code]
            when 1000001; raise Errors::InvalidPurchaseRequest.new("Invalid credit card number")
            when 1000005; raise Errors::InvalidPurchaseRequest.new("Invalid zip code")
            when 1000006; raise Errors::InvalidPurchaseRequest.new("Invalid purchase amount")
            when 1000008; raise Errors::InvalidPurchaseRequest.new("Invalid parameters: cannot specify both token and card details.")

            when 1000002; raise Errors::TransactionDenied.new("Insufficient funds")
            when 1000003; raise Errors::TransactionDenied.new("Security code check failure")
            when 1000004; raise Errors::TransactionDenied.new("Expired card")

            when 1000007; raise Errors::InvalidCardToken.new("Invalid card token")
          end
        end
      rescue HTTP::Error
        # re-raise with cause
        raise Errors::ClientError.new
      end
    end
  end
end
