class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.float :price
      t.string :description
      t.string :photo_url
      t.integer :inventory_stock

      t.timestamps
    end
  end
end
