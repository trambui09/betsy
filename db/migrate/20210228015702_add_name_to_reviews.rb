class AddNameToReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :reviews, :nickname, :string
  end
end
