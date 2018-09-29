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
    ##
    # An error raised when the FakePay payment gateway declines the payment
    # for some reason (e.g. incorrect security code or insufficient funds).
    #
    class TransactionDenied < FakePayError; end
  end
end
