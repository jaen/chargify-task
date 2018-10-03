# == Schema Information
#
# Table name: subscription_payments
#
#  id              :integer          not null, primary key
#  error           :string
#  status          :string
#  valid_to        :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  card_details_id :integer
#  subscription_id :integer
#
# Indexes
#
#  index_subscription_payments_on_card_details_id  (card_details_id)
#  index_subscription_payments_on_subscription_id  (subscription_id)
#

FactoryBot.define do
  factory :subscription_payment do
    status   { :success }
    error    { nil }
    valid_to { 1.month.from_now }
  end
end
