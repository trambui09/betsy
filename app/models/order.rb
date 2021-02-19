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

  def in_stock
    self.order_items.each do |item|
      if item.quantity > item.product.inventory_stock
        self.errors.add(:order_item, "#{item.product.name}: only #{item.product.inventory_stock} in stock. Please update the quantity of that order item in your cart.")
        return false
      end
    end

    return true
  end

  # I think I wrote this?
  def update_stock
    if self.status == "paid"
      self.order_items.each do |item|
        item.product.inventory_stock -= item.quantity
        item.product.save!
      end
    elsif self.status == "cancelled"
      self.order_items.each do |item|
        item.product.inventory_stock += item.quantity
        item.product.save!
      end
    end
  end

  # and wrote this?
  def complete_order?
    if self.order_items.all? {|item| item.fulfillment_status == "shipped"}
      self.update_attribute(:status, 'completed')
    end
  end

end
