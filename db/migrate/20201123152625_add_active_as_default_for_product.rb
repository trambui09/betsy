class AddActiveAsDefaultForProduct < ActiveRecord::Migration[6.0]
  def change
    change_column :products, :status, :string, default: "active"
  end
end
