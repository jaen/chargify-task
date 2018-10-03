require "fake_pay/client"
require "dry/transaction/operation"

module Operations
  ##
  # An operation that wraps subsequent steps in a ActiveRecord transaction.
  #
  class TransactionWrapper
    include Dry::Monads::Result::Mixin

    ##
    # Executes the operation inside a transaction.
    #
    # @param [Object] input
    #   input to the wrapped operations.
    #
    # @param [Proc] block
    #   a continuation of further operations.
    #
    def call(input, &block)
      result = nil

      ActiveRecord::Base.transaction do
        result = block.call(Success(input))
        raise ActiveRecord::Rollback if result.failure?
      end

      result
    end
  end
end
