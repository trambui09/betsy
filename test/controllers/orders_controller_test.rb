require "test_helper"

describe OrdersController do
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

    end

    it "flashes a warning when no cart is in session and redirects to homepage" do

    end
  end

  describe "checkout" do
    it "successfully checks out an order " do
      # cart = Order.create("pending")
      # order_id = session[:order_id]
      #
      # order_hash = {
      #     status: "paid"
      #     name: "Mrs. Claus",
      #     email: "mrs.claus@gmail.com",
      #     address: "North Pole",
      #     credit_card_num: 1111222233334444,
      #     exp_date: "12/20",
      #     cvv: 123,
      #     billing_zip: 12345
      # }
      #
      # expect {
      #   post paid_order_path(order_id), params: order_hash
      # }.wont_change "Order.count", 1
      #
      # new_order = Order.find_by(id: session[:order_id])
      # expect(new_order.status).must_equal order_hash[:status]
      # expect(new_order.name).must_equal order_hash[:name]
      # expect(new_order.email).must_equal order_hash[:email]
      # expect(new_order.address).must_equal order_hash[:address]
      # expect(new_order.credit_card_num).must_equal order_hash[:credit_card_num]
      # expect(new_order.exp_date).must_equal order_hash[:exp_date]
      # expect(new_order.cvv).must_equal order_hash[:cvv]
      # expect(new_order.billing_zip).must_equal order_hash[:billing_zip]
    end

    it "responds with bad request" do

    end
  end

  describe "cancel" do

  end
end
