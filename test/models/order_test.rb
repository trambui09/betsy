require "test_helper"

describe Order do
  let (:new_order) {
    Order.create(
        status: "pending",
        name: "test",
        address: " 33 test, seattle 91830",
        email: "test@testing.com",
        credit_card_num: "1111222233334444",
        exp_date: 1123,
        cvv: 345,
        billing_zip: 50505
    )
  }

  it "can be instantiated" do
    # Assert
    expect(new_order.valid?).must_equal true
  end

  it "will have the required fields" do
    # Arrange
    new_order.save
    order = Order.first
    [:status, :name].each do |field|

      # Assert
      expect(order).must_respond_to field
    end
  end


  describe "relations" do
    it 'can have many Order Items' do
      order = orders(:cart_one)

      order.order_items.each do |order_item|
        expect(order_item).must_be_instance_of OrderItem
      end
      expect(order.order_items.count).must_equal 2
    end

    it "has many products through order_items" do

      order = orders(:cart_one)

      order.products.each do |product|
        expect(product).must_be_instance_of Product
      end

      expect(order.products.count).must_equal 2

    end
  end

  describe "validations" do
    it "must have a name" do

      unless :is_pending? == true
        return new_order.name = nil
      end


      expect(new_order.valid?).must_equal false
      expect(new_order.errors.messages).must_include :name
      expect(new_order.errors.messages[:name]).must_equal ["can't be blank"]

    end
  end

  describe "custom methods" do
    describe "can have pending status" do
      it 'marks status as pending ' do

        expect(new_order.is_pending?).must_equal true
        expect(new_order.status).must_equal "pending"

      end
    end

    describe "total cart cost" do
      it "returns the subtotal of the cart" do
        # arrange
        order_1 = orders(:cart_one)
        total_cost = 0
        order_1.order_items.each do |item|
          total_cost += item.total_price
        end

        # act
        cart_total = order_1.total_cart_cost

        # assert
        expect(cart_total).must_equal total_cost

      end
    end

    describe "update_stock" do
      it "can accurately reduce the stock" do
        # arrange
        order_1 = orders(:cart_one)
        product_1 = order_1.order_items.first.product
        product_1_stock = product_1.inventory_stock
        product_1_quantity_purchased = order_1.order_items.first.quantity
        # act
        order_1.update_stock
        order_1.reload
        # assert
        expect(product_1_stock).must_equal product_1_stock -  product_1_quantity_purchased

      end
    end
  end
end
