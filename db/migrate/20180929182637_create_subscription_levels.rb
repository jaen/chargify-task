class CreateSubscriptionLevels < ActiveRecord::Migration[5.1]
  def change
    create_table :subscription_levels do |t|
      t.string :name, :null => false
      t.monetize :price, :null => false
      t.string :billing_period, :null => false

      t.timestamps
    end
  end
end
