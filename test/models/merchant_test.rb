require "test_helper"

describe Merchant do
  let (:new_merchant) {
    Merchant.new(provider: "github",
                 uid: 111,
                 email: "testing@gmail.com",
                 username: "testingname")
  }

  it "can instantiated a new merchant with the right fields" do
    expect(new_merchant.valid?).must_equal true
  end

  it "can respond to all the fields" do
    new_merchant.save
    merchant = Merchant.first

    [:provider, :uid, :email, :username].each do |field|
      expect(merchant).must_respond_to field
    end
  end

  describe "validations" do

  end

  describe "relations" do
    before do
      @merchant_1 = merchants(:merch_one)
      @merchant_3 = merchants(:merch_three)
    end
    it "can have many products" do

      @merchant_1.products.each do |product|
        expect(product).must_be_instance_of Product
      end

      expect(@merchant_1.products.count).must_equal 3
    end

    it "can have zero products" do
      expect(@merchant_3.products.count).must_equal 0
    end

  end

end
