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

require "rails_helper"

RSpec.describe CardDetails, :type => :model do
  let (:customer) { Customer.new }

  def card_details(**overrides)
    CardDetails.new(
      :customer   => customer,
      :card_token => Faker::Crypto.md5,
      **overrides)
  end

  it "is valid with all attributes specified" do
    expect(card_details).to be_valid
  end

  it "is invalid when a required attributes is missing" do
    expect(card_details(:customer   => nil)).not_to be_valid
    expect(card_details(:card_token => nil)).not_to be_valid
  end
end
