##
# Controller for handling subscriptions.
#
class SubscriptionsController < ApplicationController
  ##
  # A method that creates a subscription using {Transactions::CreateSubscription}[rdoc-ref:Transactions::CreateSubscription].
  # The endpoint returns either validation error or a dummy value simulating subscription creation.
  #
  def create
    run_transaction!(Transactions::CreateSubscription) do |result|
      result.success do |response|
        render :json => {:data => response}, :status => :created
      end

      result.failure(:validate) do |response|
        render :json => {:errors => response}, :status => :unprocessable_entity
      end
    end
  end
end
