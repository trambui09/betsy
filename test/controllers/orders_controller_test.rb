require "test_helper"

describe OrdersController do
  describe "cart" do
    it "can get to the cart" do
      get show_cart_path

      must_respond_with :success
    end
  end

  describe "show" do
    it "can get a valid order" do
      get order_path(orders(:cart_one))

      must_respond_with :success
    end

    it "will respond with not found for an invalid order" do
      get order_path(-1)

      must_respond_with :not_found
    end
  end

  describe "new" do
    it "can get to new order page when cart is in session" do
      candy_cane = products(:candy_cane)
      item_hash = {
          quantity: 1,
          product_id: candy_cane.id
      }
      post add_cart_path(candy_cane), params: item_hash

      get new_order_path

      must_respond_with :success
    end

    it "flashes a warning when no cart is in session and redirects to homepage" do
      get new_order_path

      expect(flash[:warning]).must_equal "You must have a cart in session"

      must_respond_with :redirect
      must_redirect_to root_path
    end
  end

  describe "checkout" do
    before do
      @candy_cane = products(:candy_cane)
      @item_hash = {
          quantity: 1,
          product_id: @candy_cane.id
      }
      post add_cart_path(@candy_cane), params: @item_hash
    end

    it "successfully checks out an order " do
      order_id = session[:order_id]

      order_hash = {
          name: "Mrs. Claus",
          email: "mrs.claus@gmail.com",
          address: "North Pole",
          credit_card_num: 1111222233334444,
          exp_date: 1220,
          cvv: 123,
          billing_zip: 12345
      }

      expect {
        patch paid_order_path(order_id), params: order_hash
      }.wont_change "Order.count"

      new_order = Order.find_by(id: order_id)
      expect(new_order.status).must_equal "paid"
      expect(new_order.name).must_equal order_hash[:name]
      expect(new_order.email).must_equal order_hash[:email]
      expect(new_order.address).must_equal order_hash[:address]
      expect(new_order.credit_card_num).must_equal order_hash[:credit_card_num]
      expect(new_order.exp_date).must_equal order_hash[:exp_date]
      expect(new_order.cvv).must_equal order_hash[:cvv]
      expect(new_order.billing_zip).must_equal order_hash[:billing_zip]
    end

    it "responds with bad request for invalid attributes" do
      order_id = session[:order_id]

      invalid_order_hash = {
          name: "",
          email: "",
          address: "",
          credit_card_num: 0,
          exp_date: 0,
          cvv: 0,
          billing_zip: 0
      }

      expect {
        patch paid_order_path(order_id), params: invalid_order_hash
      }.wont_change "Order.count"

      new_order = Order.find_by(id: order_id)
      expect(new_order).must_be_nil
    end

    it "responds with bad request for order item quantity exceeds inventory of product" do

    end
  end

  describe "cancel" do

  end
end
