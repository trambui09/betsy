class OrdersController < ApplicationController
  before_action :get_current_order, only: [:new, :checkout, :cancel]

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
    if @order.nil?
      flash[:warning] = "You must have a cart in session"
      redirect_to root_path
      return
    end
  end

  def checkout
    @order.status = "paid"
    # update without saving
    @order.assign_attributes(order_params)

    if @order.save
      flash[:success] = "Successfully created Order ##{@order.id}"
      # TODO: add the update_stock here
      @order.update_stock

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
    @order.update_stock
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

  def get_current_order
    @order = @current_order
  end
end

