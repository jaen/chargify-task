# == Schema Information
#
# Table name: card_details
#
#  id          :integer          not null, primary key
#  card_token  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  customer_id :integer
#
# Indexes
#
#  index_card_details_on_customer_id  (customer_id)
#

##
# A database record representing a {Customer}[rdoc-ref:Customer]'s card details.
#
class CardDetails < ApplicationRecord
  belongs_to :customer, :required => true

  validates_presence_of :card_token
end
