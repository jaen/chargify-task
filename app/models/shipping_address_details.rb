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

##
# A database record representing a {Customer}[rdoc-ref:Customer]'s shipping address details.
#
class ShippingAddressDetails < ApplicationRecord
  belongs_to :customer, :required => true

  validates_presence_of :address, :country, :name
end
