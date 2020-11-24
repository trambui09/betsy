class AddShipFieldToOrderItems < ActiveRecord::Migration[6.0]
  def change
    add_column :order_items, :fulfillment_status, :string, default: "ship"
  end
end
