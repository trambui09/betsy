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

  def total_price
    self.product.price * self.quantity
  end

  def find_order
    order = Order.find_by(id: self.order_id)
    return order
  end

  def find_product
    product = Product.find_by(id: self.product_id)
    return product
  end

  # def total_cart_cost
  #   self.map{|item| item.total_price}.sum
  # end
end
