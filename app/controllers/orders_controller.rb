class OrdersController < ApplicationController
  def index
    @order = Order.all
  end

  def show
    @order = Order.find_by(id: params[:id])
  end

  def new
    @order = Order.new(status: "pending")
  end

  def create
    @order = Order.new(order_params)

    if @order.save
      @order.status = "paid"
      flash[:success] = "Successfully created Order ##{@order.id}"
      redirect_to order_path(@order.id)
      return
    else
      flash.now[:danger] = "Failed to create order"
      render :new, status: :bad_request
    end
  end

  def destroy
    if @order
      @order.destroy
      @order.status = "cancelled"
      flash[:success] = "Successfully cancelled Order ##{@order.id}"
      redirect_to root_path
      return
    else
      head :not_found
      return
    end
  end

  private
  def order_params
    return params.require(:order).permit(:status, :name, :address, :email, :credit_card_num, :exp_date, :cvv, :zip_code)
  end
end

