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

      expect(flash[:danger]).must_equal "You must have a cart in session"

      must_respond_with :redirect
      must_redirect_to root_path
    end
  end

  describe "custom controller actions" do
    before do
      @candy_cane = products(:candy_cane)
      @item_hash = {
          quantity: 1,
          product_id: @candy_cane.id
      }
      post add_cart_path(@candy_cane), params: @item_hash
    end

    describe "checkout" do
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
        expect(session[:order_id]).must_be_nil
      end

      it "responds with bad request for invalid order attributes" do
        order_id = session[:order_id]

        invalid_order_hash = {
            name: "",
            email: "",
            address: "",
            credit_card_num: "",
            exp_date: "",
            cvv: "",
            billing_zip: ""
        }

        expect {
          patch paid_order_path(order_id), params: invalid_order_hash
        }.wont_change "Order.count"

        new_order = Order.find_by(id: order_id)
        expect(new_order.status).must_equal "pending"
        expect(flash[:danger]).must_equal "Failed to create order"
        must_respond_with :bad_request
      end

      it "redirects to cart page for order items with quantity greater than our inventory of product" do
        first_order_id = session[:order_id]

        order_hash = {
            name: "Mrs. Claus",
            email: "mrs.claus@gmail.com",
            address: "North Pole",
            credit_card_num: 1111222233334444,
            exp_date: 1220,
            cvv: 123,
            billing_zip: 12345
        }

        patch paid_order_path(first_order_id), params: order_hash

        session[:order_id] = nil

        @item_hash[:quantity] = 12
        post add_cart_path(@candy_cane), params: @item_hash
        second_order_id = session[:order_id]

        expect {
          patch paid_order_path(second_order_id), params: order_hash
        }.wont_change "Order.count"

        expect(flash[:warning]).must_equal "Order_item candy cane: only 11 in stock. Please update the quantity of that order item in your cart."
        must_respond_with :redirect
        must_redirect_to show_cart_path
      end
    end

    describe "cancel" do
      it "cancels an existing order" do
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

        patch paid_order_path(order_id), params: order_hash

        expect {
          patch cancel_order_path(order_id)
        }.wont_change "Order.count"

        cancelled_order = Order.find_by(id: order_id)
        expect(cancelled_order.status).must_equal "cancelled"
        expect(flash[:success]).must_equal "Successfully cancelled Order ##{order_id}"

        must_respond_with :redirect
        must_redirect_to root_path
      end

      it "fails to cancel invalid order and responds with not found" do
        patch cancel_order_path(-1)

        must_respond_with :not_found
      end
    end
  end
end
