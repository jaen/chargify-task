require "dry/transaction"

##
# Module containing all application transactions.
#
module Transactions
  ##
  # Base class for all application transactions.
  #
  class Base
    include Dry::Transaction

    def run!(params, &block)
      call(params, &block)
    end
  end
end
