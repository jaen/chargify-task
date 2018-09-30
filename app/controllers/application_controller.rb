##
# Base application controller.
#
class ApplicationController < ActionController::API
  def run_transaction!(transaction_klass, &block)
    params.permit!

    transaction_klass.new.run!(params, &block)
  end
end
