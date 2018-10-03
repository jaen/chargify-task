require "http"

require_relative "./errors"
require_relative "./data"

module FakePay
  ##
  # A client allowing purchase through the FakePay API.
  #
  class Client
    BASE_URL = "https://www.fakepay.io"

    ##
    # Create a +Client+ instance authenticating with the specified
    # +api_token+.
    #
    def initialize(api_token:)
      @base_url = BASE_URL
      @api_token = api_token
    end

    ##
    # Make a purchase using the FakePay API.
    #
    # The method accepts an object describing the payment request to make. This can be
    # either a first-time payment with card credentials ({FakePay::CardDetailsPurchaseRequest}[rdoc-ref:FakePay::CardDetailsPurchaseRequest])
    # or a further payment authenticated by a card token ({FakePay::CardTokenPurchaseRequest}[rdoc-ref:FakePay::CardTokenPurchaseRequest]).
    #
    # A successful payment request will return an instances of ({FakePay::PurchaseResponse}[rdoc-ref:FakePay::PurchaseResponse]) containing
    # the card token. If a payment fails, an instance of ({FakePay::Errors::FakePayError}[rdoc-ref:FakePay::Errors::FakePayError]) will be
    # thrown, describing the error.
    #
    def purchase!(request)
      currency = request.amount.currency

      unless currency == "USD"
        raise InvalidPurchaseRequest.new("Unsupported currency #{currency.iso_code}")
      end

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
            when 1000001
              raise Errors::InvalidCreditCardNumber.new("Invalid credit card number")
            when 1000005
              raise Errors::InvalidZipCode.new("Invalid zip code")
            when 1000006
              raise Errors::InvalidPurchaseAmount.new("Invalid purchase amount")
            when 1000008
              raise Errors::InvalidParameters.new(
                "Invalid parameters: cannot specify both token and card details.")

            when 1000002
              raise Errors::InsufficientFunds.new("Insufficient funds")
            when 1000003
              raise Errors::SecurityCodeCheckFailure.new("Security code check failure")
            when 1000004
              raise Errors::ExpiredCard.new("Expired card")

            when 1000007
              raise Errors::InvalidCardToken.new("Invalid card token")
          end
        end
      rescue HTTP::Error
        # re-raise with cause
        raise Errors::ClientError.new
      end
    end
  end
end
