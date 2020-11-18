class OrdersController < ApplicationController
  def show
    @order = Order.find_by(id: params[:id])

    if @order.nil?
      redirect_to orders_path
      return
    end
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)

    if @order.save
      flash[:success] = "Successfully created Order ##{@order.id}"
      redirect_to order_path(@order.id)
      return
    else
      flash.now[:danger] = "Failed to create order"
      render :new, status: :bad_request
      return
    end
  end

  private
  def order_params
    return params.require(:order).permit(:status, :name, :address, :email, :credit_card_num, :exp_date, :cvv, :zip_code)
  end
end
