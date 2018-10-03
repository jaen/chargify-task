class SubscriptionLevelSerializer < ApplicationSerializer
  attributes :id, :name, :price, :billing_period, :created_at, :updated_at

  def price
    {:cents => object.price.cents, :currency => object.price.currency_as_string}
  end

  def billing_period
    object.billing_period.iso8601
  end
end
