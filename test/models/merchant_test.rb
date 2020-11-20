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

    it "must have an username" do
      new_merchant.username = nil

      expect(new_merchant.valid?).must_equal false
      expect(new_merchant.errors.messages).must_include  :username
      expect(new_merchant.errors.messages[:username]).must_equal ["can't be blank"]

    end

    it "must have an email" do
      new_merchant.email = nil

      expect(new_merchant.valid?).must_equal false
      expect(new_merchant.errors.messages).must_include  :email
      expect(new_merchant.errors.messages[:email]).must_equal ["can't be blank"]

    end

    it "have an unique uid with given provider" do
      new_merchant.save

      invalid_uid_merchant = Merchant.new(provider: "github",
                                          uid: 111,
                                          email: "bad@gmail",
                                          username: "badname")

      expect(invalid_uid_merchant.valid?).must_equal false
      expect(invalid_uid_merchant.errors.messages).must_include :uid
      expect(invalid_uid_merchant.errors.messages[:uid]).must_equal ["uid can't be the same for same provider"]
    end
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

  describe "custom methods" do

  end
end
