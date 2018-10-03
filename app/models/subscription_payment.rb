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

##
# A database record representing a single payment attempt for a {Subscription}[rdoc-ref:Subscription].
#
# It can either be successful (+status == :success+) or failed (+status == :failure+). A successful
# attempt will extend the subscription until +valid_to+, while a failed attempt contains an +error+
# that caused the attempt to fail.
#
class SubscriptionPayment < ApplicationRecord
  extend Enumerize

  belongs_to :subscription
  belongs_to :card_details, :required => false
  enumerize :status, :in => [:success, :failure], :scope => true

  validates_presence_of :error,        :if => ->(sp) { sp.status.failure? }
  validates_presence_of :card_details, :if => ->(sp) { sp.status.success? }
end
