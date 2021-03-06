# == Schema Information
#
# Table name: customers
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

##
# A database record representing a customer of the application.
#
class Customer < ApplicationRecord
  has_many :subscriptions
  has_many :card_details, :through => :subscriptions
  has_many :shipping_address_details, :through => :subscriptions
end
