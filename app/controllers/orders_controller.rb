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
    @order = @current_order
    @order.update(order_params)
    @order.status = "paid"

    if @order.save
      # ask about this
      @cart = nil
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
    @order = @current_order
    @order.status = "cancelled"
    @order.save
    session[:order_id] = nil
    flash[:success] = "Successfully cancelled Order ##{@order.id}"
    redirect_to root_path
    return
  end

  private
  def order_params
    # why no require ordeR?
    return params.permit(:name, :email, :address, :credit_card_num, :exp_date, :cvv, :billing_zip)
  end
end

