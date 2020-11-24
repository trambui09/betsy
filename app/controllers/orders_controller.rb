class OrdersController < ApplicationController
  before_action :require_cart, only: [:new, :checkout, :cancel]

  def index
    @orders = []
    if @current_merchant
       @current_merchant.products.each do | product |
         product.orders.each do |order|
           @orders << order
         end
       end
    end
  end

  def cart
    @cart = @current_order.order_items if @current_order # && @current_order.is_pending?
  end

  def show
    @order = Order.find_by(id: params[:id])

    if @order.nil?
      head :not_found
      return
    end
  end

  def new
  end

  def checkout
    @current_order.status = "paid"
    # update without saving
    @current_order.assign_attributes(order_params)

    if @current_order.in_stock
      if @current_order.save
        flash[:success] = "Successfully created Order ##{@current_order.id}"
        # TODO: add the update_stock here
        @current_order.update_stock

        redirect_to order_path(@current_order.id)
        return
      else
        flash.now[:danger] = "Failed to create order"
        @current_order.errors.each do |column, message|
          flash.now[:warning] = "#{column.capitalize}: #{message}"
        end
        render :new, status: :bad_request
        return
      end
    else
      @current_order.errors.each do |column, message|
        flash[:warning] = "#{column.capitalize} #{message}"
      end
      redirect_to show_cart_path
      return
    end
  end

  def cancel
    @current_order.status = "cancelled"
    @current_order.save

    @current_order.update_stock

    session[:order_id] = nil
    flash[:success] = "Successfully cancelled Order ##{@current_order.id}"
    redirect_to root_path
    return
  end

  private
  def order_params
    return params.permit(:name, :email, :address, :credit_card_num, :exp_date, :cvv, :billing_zip)
  end
end

