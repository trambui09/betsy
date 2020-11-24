class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items

  with_options unless: :is_pending? do |order|
    order.validates :name, :address, :email, :credit_card_num, :exp_date, :cvv, :billing_zip, presence: true
    order.validates :cvv, :credit_card_num, numericality: { only_integer: true }
    order.validates :cvv, length: { is: 3 }
    order.validates :credit_card_num, length: { is: 16 }
  end

  def is_pending?
    return self.status == "pending"
  end

  def total_cart_cost
    return self.order_items.map(&:total_price).sum
  end

  def update_stock
    self.order_items.each do |item|
      item.product.inventory_stock -= item.quantity
      item.product.save!
    end
  end
end
