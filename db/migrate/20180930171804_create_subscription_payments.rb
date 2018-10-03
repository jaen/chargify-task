class CreateSubscriptionPayments < ActiveRecord::Migration[5.1]
  def change
    create_table :subscription_payments do |t|
      t.string :status
      t.string :error
      t.datetime :valid_to
      t.references :subscription, :foreign_key => true
      t.references :card_details, :foreign_key => true

      t.timestamps
    end
  end
end
