class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

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
end
