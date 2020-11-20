class OrderItemsController < ApplicationController
  def create
    if session[:order_id].nil?
      # need to figure out where quantity gets stored when submitting form
      # make form for quantity, which you would get quantity when you submit
      # submit via post request with nested route, and controller can be for orderitems#create
      @order = Order.create(status: "pending")
      session[:order_id] = @order.id
    end

    @item = OrderItem.new(quantity: params[:id][:quantity], product_id: params[:id], order_id: session[:order_id])

    if @item.save
      flash[:success] = "Successfully added item to your cart"
    else
      @item.errors.each do |column, message|
        flash[:warning] = message
      end
    end

    redirect_back fallback_location: '/'
  end

  def edit
    @item = OrderItem.find_by(id: params[:id])

    if @item.nil?
      redirect_to orders_path
      return
    end
  end

  def update
    @item = OrderItem.find_by(id: params[:id])

    if @item.nil?
      redirect_to orders_path
      return
    elsif @item.update(quantity: params[:id][:quantity])
      flash[:success] = "Quantity successfully updated"
      redirect_to orders_path
      return
    else
      render :edit, status: :bad_request
      return
    end
  end
end
