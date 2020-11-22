require "test_helper"

describe OrderItemsController do
  describe "create" do
    before do
      @candy_cane = products(:candy_cane)
      @item_hash = {
          quantity: 1,
          product_id: @candy_cane.id
      }
    end

    it "creates a new cart and session associated with that cart" do
      expect {
        post add_cart_path(@candy_cane), params: @item_hash
      }.must_change 'Order.count', 1
      expect(session[:order_id]).must_equal Order.last.id
    end

    it "creates a new cart if deleted from db but not from session" do
      post add_cart_path(@candy_cane), params: @item_hash
      cart_id = session[:order_id]

      Order.delete_all
      post add_cart_path(@candy_cane), params: @item_hash

      expect(session[:order_id]).wont_equal cart_id
      expect(Order.count).must_equal 1
      expect(session[:order_id]).must_equal Order.first.id
    end

    it "updates quantity of item if it exists in cart" do
      post add_cart_path(@candy_cane), params: @item_hash

      @item_hash[:quantity] = 5
      @item_hash[:order_id] = session[:order_id]

      expect {
        post add_cart_path(@candy_cane), params: @item_hash
      }.wont_change 'OrderItem.count'

      order_item = OrderItem.find_by(product: @candy_cane)

      expect(order_item.quantity).must_equal 1 + 5
    end

    it "creates a new order item if not in db and redirects" do
      expect {
        post add_cart_path(@candy_cane), params: @item_hash
      }.must_change 'OrderItem.count', 1

      new_item = OrderItem.find_by(product_id: @item_hash[:product_id])
      expect(new_item.quantity).must_equal @item_hash[:quantity]

      expect(flash[:success]).must_equal "Successfully added item to your cart"
      must_respond_with :redirect
    end

    it "does not create an order item if form data violates validations and responds with redirect" do
      invalid_quantity = {
          quantity: -1,
          product_id: @candy_cane,
      }

      expect {
        post add_cart_path(@candy_cane), params: invalid_quantity
      }.wont_change 'OrderItem.count'
      must_respond_with :redirect
    end
  end

  describe "update" do
    before do
      @cookies = order_items(:cookie_items)
    end

    it "can update an existing order item with valid information accurately and redirect" do
      edited_item_hash = {
          quantity: 12
      }

      expect {
        patch order_item_path(@cookies), params: edited_item_hash
      }.wont_change 'OrderItem.count'

      edited_item = OrderItem.find_by(id: @cookies.id)
      expect(edited_item.quantity).must_equal edited_item_hash[:quantity]

      expect(flash[:success]).must_equal "Quantity successfully updated"
      must_respond_with :redirect
      must_redirect_to show_cart_path
    end

    it "does not update any order item if given an invalid id, and redirects to cart" do
      edited_item_hash = {
          quantity: 12
      }

      expect {
        patch order_item_path(-1), params: edited_item_hash
      }.wont_change 'OrderItem.count'

      must_respond_with :redirect
      must_redirect_to show_cart_path
    end

    it "does not edit an order item if the form data violates validations and responds with a bad request" do
      edited_item_hash = {
          quantity: nil
      }

      expect {
        patch order_item_path(@cookies), params: edited_item_hash
      }.wont_change 'OrderItem.count'

      expect(flash[:danger]).must_equal "Failed to update item"
      must_respond_with :bad_request
    end
  end

  describe "destroy" do
    before do
      @ornament = order_items(:ornament_items)
    end
    it "removes item from cart in db when work exists, and then redirects" do
      expect {
        delete order_item_path(@ornament)
      }.must_change 'OrderItem.count', -1

      deleted_item = OrderItem.find_by(id: @ornament.id)

      expect(deleted_item).must_be_nil

      expect(flash[:success]).must_equal "Successfully removed ornament from your cart"
      must_respond_with :redirect
      must_redirect_to show_cart_path
    end

    it "does not change the db when the work does not exist, then responds with not found" do
      expect {
        delete order_item_path(-1)
      }.wont_change 'OrderItem.count'

      must_respond_with :not_found
    end
  end
end
