require "test_helper"

describe Product do
  before do
    @merchant = merchants(:merch_one)
  end
  let (:new_product) {
    Product.new(name: "product test",
                price: 24.50,
                merchant_id: @merchant.id,
                description: "testing description",
                photo_url: "testing.com",
                inventory_stock: 5)
  }

  it "can instantiated a product " do
    expect(new_product.valid?).must_equal true
  end

  it "will have required fields" do
    new_product.save
    product = Product.first

    [:name, :price, :description, :inventory_stock, :merchant_id, :photo_url].each do |field|
      expect(product).must_respond_to field
    end
  end

  describe "validations" do
    it "must have a name" do

    end

  end

  describe  "relations" do

  end
end
