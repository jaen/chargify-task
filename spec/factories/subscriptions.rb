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

FactoryBot.define do
  factory :subscription do
    subscription_level { SubscriptionLevel.all.sample }
    customer
  end
end
