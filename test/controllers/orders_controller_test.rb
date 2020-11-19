require "test_helper"

describe OrdersController do
  # before do
  #   @order =Order.create(status:"paid", name:"test name", address:"890 test ", email: "test email", credit_card_num: 99999999999999999, exp_date: 11/24, cvv: 342, billing_zip: 98765)
  # end
  # before do
  #   @order = (:cart_one)
  # end
  describe 'show'  do
    before do
      @order = Order.create(status:"paid", name:"test name", address:"890 test ", email: "test email", credit_card_num: 123456, exp_date: 11/24, cvv: 342, billing_zip: 98765)
    end
    it 'will show an order' do
      id = @order.id
      get orders_path(@order.id)
      must_respond_with :success
    end
  end
end
