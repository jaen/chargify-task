# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ :name => "Star Wars" }, { :name => "Lord of the Rings" }])
#   Character.create(:name => "Luke", :movie => movies.first)

SUBSCRIPTION_LEVELS = [
  {:name => "Bronze Box", :price => Money.new(1999, :usd), :billing_period => 1.month},
  {:name => "Silver Box", :price => Money.new(4900, :usd), :billing_period => 1.month},
  {:name => "Gold Box",   :price => Money.new(9900, :usd), :billing_period => 1.month}
]

SUBSCRIPTION_LEVELS.each do |level|
  SubscriptionLevel.where(:name => level[:name]).first_or_create(level)
end
