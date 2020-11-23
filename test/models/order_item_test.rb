require "test_helper"

describe OrderItem do
  let(:new_order) {
    OrderItem.new(quantity: 1,
                  product: products(:product_three),
                  order: orders(:cart_one))
  }
  describe "validations" do

    it "can be instantiated with valid data" do

      expect(new_order.valid?).must_equal true
    end
  end

  # it "does a thing" do
  #   value(1+1).must_equal 2
  # end

  describe "relations" do

  end

  describe "custom methods" do
    describe "total_price" do
      it "return the total price of each item with the quantity" do

        orderitem_1 = order_items(:tree_items)
        total_item_price = orderitem_1.quantity * orderitem_1.product.price

        total_price = orderitem_1.total_price

        expect(total_price).must_equal total_item_price

      end
    end
  end
end
