##
# Controller for handling subscriptions.
#
class SubscriptionsController < ApplicationController
  ##
  # A method that creates a subscription using {Transactions::CreateSubscription}[rdoc-ref:Transactions::CreateSubscription].
  # The endpoint returns either validation error or a persisted {Subscription}[rdoc-ref:Subscription].
  #
  def create
    Transactions::CreateSubscription.new.run!(params.permit!) do |on|
      on.success do |subscription|
        render :status     => :created,
               :json       => subscription,
               :serializer => CreateSubscriptionSerializer
      end

      on.failure do |exception|
        render :status     => :unprocessable_entity,
               :json       => exception,
               :serializer => ErrorSerializer
      end
    end
  end
end
