# == Schema Information
#
# Table name: subscription_levels
#
#  id             :integer          not null, primary key
#  billing_period :string           not null
#  name           :string           not null
#  price_cents    :integer          default(0), not null
#  price_currency :string           default("USD"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

##
# A database record representing a subscription level for the product.
#
class SubscriptionLevel < ApplicationRecord
  monetize :price_cents, :allow_nil => true
  attribute :billing_period, :duration

  validates_presence_of :name, :price_cents, :billing_period
end
