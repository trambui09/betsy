class Merchant < ApplicationRecord
  has_many :products
  has_many :order_items, through: :products

  validates :username, :email, presence: true
  validates :uid, uniqueness: { scope: :provider,
                                message: "uid can't be the same for same provider" }

  def self.build_from_github(auth_hash)
    merchant = Merchant.new
    merchant.uid = auth_hash[:uid]
    merchant.provider = "github"
    merchant.username = auth_hash["info"]["nickname"]
    merchant.email = auth_hash["info"]["email"]

    # Note that the merchant has not been saved.
    # We'll choose to do the saving outside of this method
    return merchant
  end

  def total_revenue

    total_revenue = 0

    self.order_items.each do |item|
      if item.order.status == "cancelled"
        next
      end
      total_revenue += item.quantity * item.product.price
    end
    return total_revenue
  end

  def total_orders_by_status(status)
    status_hash = Hash.new(0)

    self.order_items.each do |order_item|
      if order_item.order.status == status
        status_hash[order_item.order.id] = status
      end
    end
    
    return status_hash.values.count(status)
  end

  # TODO: unit test
  def total_revenue_by_status(status)
    revenue = 0

    self.order_items.each do |item|
      if item.order.status != status
        next
      end
      revenue += item.quantity * item.product.price
    end
    return revenue


  end

  # get all the orders that the current merchant has
  # TODO: unit test for custom method
  def total_orders
    orders = []
    self.order_items.each do |order_item|
      unless orders.include?(order_item.order.id)
        orders.push(order_item.order.id)
      end
    end

    return orders.size
  end
end
