# == Schema Information
#
# Table name: subscriptions
#
#  id                          :integer          not null, primary key
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  customer_id                 :integer
#  shipping_address_details_id :integer
#  subscription_level_id       :integer
#
# Indexes
#
#  index_subscriptions_on_customer_id                  (customer_id)
#  index_subscriptions_on_shipping_address_details_id  (shipping_address_details_id)
#  index_subscriptions_on_subscription_level_id        (subscription_level_id)
#

##
# A database record representing a single subscription for the product at a given
# {SubscriptionLevel}[SubscriptionLevel].
#
class Subscription < ApplicationRecord
  belongs_to :subscription_level
  belongs_to :customer
  belongs_to :shipping_address_details
  has_many   :subscription_payments
  has_many   :card_details, :through => :subscription_payments
  has_one    :last_successful_payment, -> { with_status(:success).limit(1) }, :class_name => "SubscriptionPayment"

  ##
  # @param [DateTime] date the the validity of subscription is to be tested at (always rounded to the end of the day).
  # @return [Boolean] +true+ if the subscription is valid on the given +date+, +false otherwise.
  #
  def subscription_valid?(date = DateTime.now)
    if last_successful_payment
      date.end_of_day <= last_successful_payment.valid_to
    else
      false
    end
  end
end
