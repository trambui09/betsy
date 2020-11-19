require "test_helper"

describe OrdersController do
  describe "index" do
    it "will redirect when a user tries to get the page and isn't logged in" do
      get orders_path

      must_respond_with :redirect
      must_redirect_to root_path

    end
  end
end
