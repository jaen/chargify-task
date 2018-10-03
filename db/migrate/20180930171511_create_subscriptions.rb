class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.references :subscription_level, :foreign_key => true
      t.references :customer, :foreign_key => true
      t.references :shipping_address_details, :foreign_key => true

      t.timestamps
    end
  end
end
