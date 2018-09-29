class CreateCardDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :card_details do |t|
      t.references :customer

      t.string :card_token

      t.timestamps
    end
  end
end
