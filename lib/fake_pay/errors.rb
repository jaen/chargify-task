module FakePay
  module Errors
    class FakePayError           < StandardError; end
    class ClientError            < FakePayError; end
    class InvalidCardToken       < FakePayError; end
    class InvalidPurchaseRequest < FakePayError; end
    class TransactionDenied      < FakePayError; end
  end
end
