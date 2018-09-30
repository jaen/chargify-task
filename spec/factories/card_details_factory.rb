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

FactoryBot.define do
  ##
  # Creates a +CardDetails+ database model.
  #
  factory :card_details do
    customer
    card_token { Faker::Crypto.md5 }
  end
end
