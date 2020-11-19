class AddBillingInfoToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :name, :string
    add_column :orders, :address, :string
    add_column :orders, :email, :string
    add_column :orders, :credit_card_num, :integer
    add_column :orders, :exp_date, :integer
    add_column :orders, :cvv, :integer
    add_column :orders, :billing_zip, :integer
  end
end
