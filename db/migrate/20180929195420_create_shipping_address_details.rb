class CreateShippingAddressDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :shipping_address_details do |t|
      t.references :customer

      t.string :name
      t.string :address
      t.string :country
      t.string :zip_code

      t.timestamps
    end
  end
end
