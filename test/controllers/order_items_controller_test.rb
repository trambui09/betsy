require "test_helper"

describe OrderItemsController do

  # let(:new_order_item) {
  #   OrderItem.create(product: products(:product_one), quantity: 2)
  # }

  # describe "create" do
  #   it "can add an item to the order " do
  #     product = Product.first
  #     order = Order.first
  #
  #     order_item_hash = {
  #         order_item: {
  #             product_id: product.id,
  #             order_id: order.id,
  #             quantity: 1
  #         }
  #     }
  #
  #     expect {
  #       post order_items_path, params: order_item_hash
  #     }.must_change "OrderItem.count", 1
  #
  #     new_item = OrderItem.find_by(quantity: order_item_hash[:order_item][:quantity])
  #     expect(order_item_hash.product_id).must_equal order_item_hash[:order_item][:product_id]
  #
  #     must_respond_with :redirect
  #     must_redirect_to product_path(new_item.id)
  #
  #   end
  # end
end
