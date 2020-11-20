class Merchant < ApplicationRecord
  has_many :products

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
end
