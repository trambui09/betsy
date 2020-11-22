class OrdersController < ApplicationController
  def cart
    @cart = @current_order.order_items if @current_order
  end

  def show
    @order = Order.find_by(id: params[:id])

    if @order.nil?
      head :not_found
      return
    end
  end

  def new
    @order = @current_order

    if @order.nil?
      flash[:warning] = "You must have a cart in session"
      redirect_to show_cart_path
      return
    end
  end

  def update
    raise
    @order = @current_order.assign_attributes(order_params)
    @order.status = "paid"

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
    return params.require(:order).permit(:name, :email, :address, :credit_card_num, :exp_date, :cvv, :billing_zip)
  end
end

