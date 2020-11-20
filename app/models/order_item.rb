class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def in_stock?
    product = Product.find_by(id: self.product_id)

    if product.inventory_stock == 0
      flash[:error] = "Product #{product.name} is out of stock!"
    end
  end

  # def check_inventory
  #   if self.quantity > product.inventory_stock
  #     flash[:error] = ""
  #   end
  # end
end
