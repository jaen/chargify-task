# == Schema Information
#
# Table name: shipping_address_details
#
#  id          :integer          not null, primary key
#  address     :string
#  country     :string
#  name        :string
#  zip_code    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  customer_id :integer
#
# Indexes
#
#  index_shipping_address_details_on_customer_id  (customer_id)
#

require "rails_helper"

RSpec.describe ShippingAddressDetails, :type => :model do
  let (:customer) { Customer.new }

  def shipping_address_details(**overrides)
    ShippingAddressDetails.new(
      :customer => customer,
      :name     => Faker::Name.name,
      :address  => Faker::Address.full_address,
      :country  => Faker::Address.country_code,
      :zip_code => Faker::Address.zip_code,
      **overrides)
  end

  it "is valid with all attributes specified" do
    expect(shipping_address_details).to be_valid
  end

  it "is valid when an optional attribute is missing" do
    expect(shipping_address_details(:zip_code => nil)).to be_valid
  end

  it "is invalid when a required attributes is missing" do
    expect(shipping_address_details(:customer => nil)).not_to be_valid
    expect(shipping_address_details(:name     => nil)).not_to be_valid
    expect(shipping_address_details(:address  => nil)).not_to be_valid
    expect(shipping_address_details(:country  => nil)).not_to be_valid
  end
end
