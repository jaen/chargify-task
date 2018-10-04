desc "Charges subscription expiring at the end of this day."
task :charge_expired_subscriptions => [:environment] do
  Rails.logger = Logger.new(STDOUT)

  validation_date = DateTime.now.end_of_day

  Subscription.all.find_in_batches(:batch_size => 50) do |batch|
    batch.each do |subscription|
      if subscription.last_successful_payment
        unless subscription.subscription_valid?(validation_date)
          Rails.logger.info("Subscription #{subscription.inspect} is expired, charging.")

          card_details_id = subscription.last_successful_payment.card_details_id

          Transactions::ChargeSubscription.new
            .with_step_args(:charge! => [:card_details_id => card_details_id])
            .run!(subscription) do |on|
              on.success do |subscription|
                Rails.logger.info("Subscription succesfully extended for #{subscription.subscription_level.billing_period.iso8601}.")
              end

              on.failure do |error|
                Rails.logger.info("Failed to extend subscription: #{error}.")
              end
            end
        else
          Rails.logger.info("Subscription #{subscription.inspect} is still valid.")
        end
      else
        Rails.logger.info("Subscription #{subscription.inspect} cannot be charged due to lack of card token.")
      end
    end
  end
end
