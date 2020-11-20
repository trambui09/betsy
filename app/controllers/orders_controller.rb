class OrdersController < ApplicationController
  def index
    @cart = @current_cart.products
  end

  def show
    @order = Order.find_by(id: params[:id])
    if @order.nil?
      head :not_found
    end
  end

  def new
    if session[:order_id]
      @order = Order.new(status: "pending")
    else
      redirect_to orders_path
      return
    end
  end

  def create
    @order = Order.new(order_params)

    if @order.save
      @order.status = "paid"
      @order.save
      flash[:success] = "Successfully created Order ##{@order.id}"
      redirect_to order_path(@order.id)
      return
    else
      flash.now[:danger] = "Failed to create order"
      render :new, status: :bad_request
      return
    end
  end

  def cancel
    @order.status = "cancelled"
    @order.save
    session[:order_id] = nil
    flash[:success] = "Successfully cancelled Order ##{@order.id}"
    redirect_to root_path
    return
  end

  private
  def order_params
    return params.require(:order).permit(:name, :address, :email, :credit_card_num, :exp_date, :cvv, :billing_zip)
  end
end

