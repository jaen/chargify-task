##
# Controller for handling subscriptions.
#
class SubscriptionsController < ApplicationController
  ##
  # A method that creates a subscription using {Transactions::CreateSubscription}[rdoc-ref:Transactions::CreateSubscription].
  # The endpoint returns either validation error or a persisted {Subscription}[rdoc-ref:Subscription].
  #
  def create
    run_transaction!(Transactions::CreateSubscription) do |on|
      on.success do |subscription|
        render :status     => :created,
               :json       => {:data => {:subscription => subscription}}
      end

      on.failure do |exception|
        render :status     => :unprocessable_entity,
               :json       => {:errors => exception}
      end
    end
  end
end
