class CreateSubscriptionSerializer < ApplicationSerializer
  type :subscription

  attributes :id, :created_at, :updated_at

  belongs_to :subscription_level
  belongs_to :customer
  belongs_to :shipping_address_details
  has_many   :subscription_payments

  class SubscriptionLevelSerializer < ApplicationSerializer
    attributes :name, :price, :billing_period

    def price
      {:cents => object.price.cents, :currency => object.price.currency.to_s}
    end

    def billing_period
      object.billing_period.iso8601
    end
  end

  class ShippingAddressDetailsSerializer < ApplicationSerializer
    attributes :name, :address, :country, :zip_code
  end

  class SubscriptionPaymentSerializer < ApplicationSerializer
    attributes :status, :valid_to
    attribute  :error, :if => -> { object.error.present? }
  end
end
