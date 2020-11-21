require "test_helper"

describe OrdersController do

  describe 'show'  do
    before do
      @order = Order.create(status:"paid", name:"test name", address:"890 test ", email: "test email", credit_card_num: 1234567891234567, exp_date: 11/24, cvv: 342, billing_zip: 98765)
    end
    # it 'will show an order' do
    #   id = @order.id
    #   get order_path(@order.id)
    #   must_respond_with :success
    # end
    describe "new" do

      it "will create a new order" do
        get new_order_path
        must_respond_with :success
      end
    end
    describe "create" do

      it " will not create order when given an invalid order id" do

        order_hash = {
            order: {
                status: "",
                name: "",
                address: "",
                email: "",
                credit_card_num: "",
                cvv: "",
                billing_zip: ""

            }
        }
        expect{
          post orders_path,params:order_hash
        }.wont_change "Order.count"
        end
    end
  end
end
