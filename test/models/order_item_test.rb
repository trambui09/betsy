require "test_helper"

describe OrderItem do
  # it "does a thing" do
  #   value(1+1).must_equal 2
  # end

  describe "relations" do

  end

  describe "validations" do

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
