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

require "rails_helper"

RSpec.describe SubscriptionLevel, :type => :model do
  def subscription(**overrides)
    SubscriptionLevel.new(
      :name           => "Bronze Box",
      :price          => Money.new(1999, :usd),
      :billing_period => 1.month,
      **overrides)
  end

  it "is valid with all attributes specified" do
    expect(subscription).to be_valid
  end

  it "is invalid when an attributes is missing" do
    expect(subscription(:name => nil)).not_to be_valid
    expect(subscription(:price => nil)).not_to be_valid
    expect(subscription(:billing_period => nil)).not_to be_valid
  end
end
