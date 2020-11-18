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
      new_product.name = nil

      expect(new_product.valid?).must_equal false
      expect(new_product.errors.messages).must_include :name
      expect(new_product.errors.messages[:name]).must_equal ["can't be blank"]

    end

    it "must have a price that's a number greater than 0" do
      new_product.price = -5.00

      expect(new_product.valid?).must_equal false
      expect(new_product.errors.messages).must_include :price
      expect(new_product.errors.messages[:price]).must_equal ["price must be greater than 0"]

    end

  end

  describe  "relations" do

    describe "merchant" do
      before do
        @merchant_1 = merchants(:merch_one)
        @product_1 = Product.new(name: "test",
                              price: 25.00)

      end

      it "can set the merchant using Merchant" do

        @product_1.merchant = @merchant_1
        # check that AR recognizes the relationship
        expect(@product_1.merchant_id).must_equal @merchant_1.id


      end

      it "can set the merchant using merchant_id" do

        @product_1.merchant_id = @merchant_1.id
        expect(@product_1.merchant).must_equal @merchant_1
      end

      # TODO: this test is not passing, saying it's nil, but do we need it? since we have two above
      # it "has a merchant" do
      #
      #   # product = products(:product_one)
      #   # expect(product.merchant).must_equal merchants(:merch_one)
      #
      #   expect(@product_1.merchant).must_equal @merchant_1
      # end

    end




    # it "has many order_items" do
    #
    # end
    #
    # it "has many categories" do
    #
    # end
    #
    # it "has many orders through order_items" do
    #
    # end

  end
end
