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
      expect(new_merchant.errors.messages).must_include :username
      expect(new_merchant.errors.messages[:username]).must_equal ["can't be blank"]
    end

    it "must have an email" do

      new_merchant.email = nil

      expect(new_merchant.valid?).must_equal false
      expect(new_merchant.errors.messages).must_include :email
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
    describe "self.build_from_github" do
      # I don't think we have tested this before
      it "can create a merchant from the auth_hash" do
        # arrange
        auth_hash = {
            provider: "github",
            uid: 222,
            "info" => {
                "nickname" => "bettyboo",
                "email" => "bettybooo@gmail.com"
            }
        }
        # act
        start_count = Merchant.count
        merchant = Merchant.build_from_github(auth_hash)
        merchant.save!

        # assert
        expect(Merchant.count).must_equal start_count + 1
        expect(merchant.username).must_equal auth_hash["info"]["nickname"]
        expect(merchant.uid).must_equal auth_hash[:uid]
        expect(merchant.email).must_equal auth_hash["info"]["email"]
      end
    end

    describe "total revenue" do
      before do
        @merchant = merchants(:merch_four)
        @product_one = products(:product_one)
        @product_two = products(:product_three)
      end

      it "correctly calculates total revenue for one specific merchant" do
        total = 0
        @merchant.order_items.each do |item|
          total += item.quantity * item.product.price
        end

        expect(@merchant.total_revenue).must_equal total
      end

      it "will return 0 if merchant has no sales" do
        expect(merchants(:merch_five).total_revenue).must_equal 0
      end

      it "can calculate total revenue for various items" do
        merch_four_total = 0
        merchants(:merch_four).order_items.each do |item|
          merch_four_total += item.quantity * item.product.price
        end

        expect(merchants(:merch_four).total_revenue).must_equal merch_four_total

      end
    end
    describe "total_orders_by_status" do

      it "will display number of orders by status for merchant" do
        expect(merchants(:merch_four).total_orders_by_status("complete")).must_equal 1
      end

      it "will return 0 for non-existing status" do
        expect(merchants(:merch_four).total_orders_by_status("")).must_equal 0
    end
    end

    describe "total_revenue_by_status" do

    end

    describe "total_orders" do
      it "will return 0 if merchant has no orders" do

      end

      it "will return the number of total orders" do

      end
    end
  end
end
