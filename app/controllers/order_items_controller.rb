class OrderItemsController < ApplicationController
  before_action :find_item, only: [:edit, :update]

  def create
    raise
    if session[:order_id].nil?
      @order = Order.create(status: "pending")
      session[:order_id] = @order.id
    end

    @item = OrderItem.new(quantity: params[:post][:quantity].to_i, product_id: params[:id], order_id: session[:order_id])

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
    if @item.nil?
      redirect_to orders_path
      return
    end

    @item = OrderItem.new(quantity: params[:quantity], product_id: @product.id, order_id: @order.id)

    #save order with the new item
    if @item.save
      if params[:order_id, :product_id]
      flash[:status] = :success
      flash[:message] = "Item successfully added to cart"
      redirect_to order_item_path(@item.id)
      else
        redirect_to product_path(@product.id)
      end
    else
      flash[:status] = :error
      render :new, status: :bad_request
      flash[:message] = "Error. Order cannot be saved."
      end
  end

  # def edit
  #   @order = Order.find_by(id:params[:id])
  #
  #   if @order.nil?
  #     redirect_to orders_path
  #     return
  #   end
  # end

  def update
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

  private
  def find_item
    @item = OrderItem.find_by(id: params[:id])
  end

  def item_params
    params.require(:order_item).permit(:quantity, :product_id)
  end
end