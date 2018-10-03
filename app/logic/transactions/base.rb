require "dry/transaction"

##
# Module containing all application transactions.
#
module Transactions
  ##
  # A shim for a `Dry::Container` that allows for simple usage of operations specified as class constants.
  #
  module InstantiateClassContainer
    def self.[](klass)
      klass.new
    end

    def self.key?(_)
      true
    end
  end


  ##
  # Base class for all application transactions.
  #
  class Base
    include Dry::Transaction(:container => InstantiateClassContainer)

    ##
    # Execute a transaction.
    #
    alias_method :run!, :call
  end
end
