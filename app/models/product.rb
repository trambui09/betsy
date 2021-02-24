class Product < ApplicationRecord
  has_and_belongs_to_many :categories
  belongs_to :merchant
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :reviews


  validates :name, presence: true
  # price must be present, a num, and greater than 0
  validates :price, presence: true, numericality: { greater_than: 0 ,
                                                    message: "price must be greater than 0"}

  # TODO: merchant can't write review for their own products
  # where would I put that check?

  def self.recently_added
    return Product.order('created_at DESC').limit(6)
  end

  def average_rating
    if self.reviews.size > 0
      self.reviews.average(:rating)
    else
      'no one has rated this item yet, be the first one!'
    end
  end

end
