class OrdersController < ApplicationController
  def index
    @order = Order. all
  end

  def edit
    @order = Order.find_by(id:params[:id])

    if @order.nil?
      redirect_to orders_path
      return
    end
  end

  def update
    @order = Order.find_by(id:params[:id])
    # we will need to add how to check if item has stock
    if @order.nil?
      redirect_to product_path
      return
    elsif @order.update(order_params)
      flash[:success] = "You have successfully ordered #{@order}"
      redirect_to order_path(@order)
      return
    else
      render :edit, status: :bad_request
      return
    end
  end

end

