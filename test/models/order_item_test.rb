require "test_helper"

describe OrderItem do
  let(:new_order_item) {
    OrderItem.new(quantity: 1,
                  product: products(:product_three),
                  order: orders(:cart_one))
  }
  describe "validations" do

    it "can be instantiated with valid data" do

      expect(new_order_item.valid?).must_equal true
    end
  end

  it "is valid when all fields are present" do
    new_order_item = order_items(:ornament_items)
    result = new_order_item.valid?

    expect(result).must_equal true
  end

  it "is invalid when a quantity is not present" do
    new_order_item = order_items(:cookie_items)
    new_order_item.quantity = nil
    result = new_order_item.valid?

    expect(result).must_equal false
  end

  it "is invalid with a quantity of zero or less" do
    new_order_item = order_items(:tree_items)
    new_order_item.quantity = 0
    result = new_order_item.valid?

    expect(result).must_equal false
  end

  it "is is valid with a quantity of greater than zero" do
    new_order_item = order_items(:ornament_items)
    result = new_order_item.valid?

    expect(result).must_equal  true
  end

  it "is invalid when the quantity is not an integer" do
    new_order_item = order_items(:cookie_items)
    new_order_item.quantity = 2.8

    expect(new_order_item.valid?).must_equal false
  end

  describe "relationships" do


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
