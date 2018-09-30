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

FactoryBot.define do
  ##
  # Creates a +ShippingAddressDetails+ database model.
  #
  factory :shipping_address_details do
    customer
    name     { Faker::Name.name }
    address  { Faker::Address.full_address }
    country  { Faker::Address.country_code }
    zip_code { Faker::Address.zip_code }
  end
end
