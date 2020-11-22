require "test_helper"

describe MerchantsController do
  describe "auth_callback" do
    it "logs in an existing merchant and redirects to the root route" do
      # Count the merchants, to make sure we're not (for example) creating
      # a new merchant every time we get a login request
      start_count = Merchant.count

      # Get a merchant from the fixtures
      merchant = merchants(:merch_two)

      perform_login(merchant)

      # Send a login request for that user
      # Note that we're using the named path for the callback, as defined
      # in the `as:` clause in `config/routes.rb`
      get auth_callback_path(:github)

      must_redirect_to root_path

      # Since we can read the session, check that the merchant ID was set as expected
      session[:merchant_id].must_equal merchant.id

      # Should *not* have created a new merchant
      Merchant.count.must_equal start_count
    end

    it "creates an account for a new merchant and redirects to the root route" do
      start_count = Merchant.count
      merchant = Merchant.new(provider: "github", uid: 99999, username: "test_merchant", email: "test@merchant.com")

      perform_login(merchant)
      get auth_callback_path(:github)

      must_redirect_to root_path

      # Should have created a new merchant
      Merchant.count.must_equal start_count + 1

      # The new merchant's ID should be set in the session
      session[:merchant_id].must_equal Merchant.last.id
    end

    it "redirects to the login route if given invalid merchant data" do
      start_count = Merchant.count
      merchant = Merchant.new(provider: "github", uid: 99999, username: "", email: "")

      perform_login(merchant)
      get auth_callback_path(:github)

      # Should *not* have created a new merchant
      Merchant.count.must_equal start_count
      must_redirect_to root_path
    end
  end

  describe "logout" do
    it "can log out a logged in merchant" do
      perform_login
      expect(session[:merchant_id]).wont_be_nil

      post logout_path
      expect(session[:merchant_id]).must_be_nil

      expect(flash[:success]).must_equal "Successfully logged out"
      must_respond_with :redirect
      must_redirect_to root_path
    end
  end

  describe "index" do
    it "can load all merchants" do
      get merchants_path
      must_respond_with :ok
    end
  end
end
