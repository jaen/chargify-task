module FakePay
  ##
  # FakePay client error types.
  #
  module Errors
    ##
    # A generic FakePay error.
    #
    class FakePayError < StandardError; end
    ##
    # An error raised when the underlying HTTP client errors out.
    #
    class ClientError < FakePayError; end
    ##
    # An error raised when the card token is invalid (e.g. doesn't exist in
    # the FakePay gateway).
    #
    class InvalidCardToken < FakePayError; end
    ##
    # An error raised when the purchase request was invalid (e.g. missing fields or
    # incorrect field values).
    #
    class InvalidPurchaseRequest < FakePayError; end

    class InvalidCreditCardNumber < InvalidPurchaseRequest; end
    class InvalidZipCode          < InvalidPurchaseRequest; end
    class InvalidPurchaseAmount   < InvalidPurchaseRequest; end
    class InvalidParameters       < InvalidPurchaseRequest; end

    ##
    # An error raised when the FakePay payment gateway declines the payment
    # for some reason (e.g. incorrect security code or insufficient funds).
    #
    class TransactionDenied < FakePayError; end

    class InsufficientFunds        < TransactionDenied; end
    class SecurityCodeCheckFailure < TransactionDenied; end
    class ExpiredCard              < TransactionDenied; end
  end
end
