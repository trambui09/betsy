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
    return status == "pending"
  end
end
