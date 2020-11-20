class OrderItemsController < ApplicationController


  def create

    @order = Order.find_by(id:params[:order_id])
    if @order.nil?
      flash[:status] = :error
      flash[:message] ="Order does not exist"
      render :new, status: :bad_request
      return
    end

    @product = Product.find_by(id:params[:product_id])
    if@product.nil?
      flash[:status] = :error
      flash[:message] ="Product does not exist"
      render :new, status: :bad_request
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
    @order = Order.find_by(id:params[:id])
    # we will need to add how to check if item has stock
    if @order.nil?
      redirect_to product_path
      return
    elsif @order.update(order_params)
      flash[:success] = "You have successfully updated order"
      redirect_to order_path(@order)
      return
    else
      render :edit, status: :bad_request
      return
    end
  end
end

private

def item_params
  params.require(:order_item).permit(:quantity, :product_id)
end