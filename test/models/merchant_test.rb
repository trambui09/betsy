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

end
