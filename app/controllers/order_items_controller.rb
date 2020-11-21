class OrderItemsController < ApplicationController
  before_action :find_item, only: [:update, :destroy]

  def create
    # unless you quit your browser, session remains unchanged
    # dropping and reseeding the database deletes cart associated with the session
    if session[:order_id].nil? || Order.find_by(id: session[:order_id]).nil?
      @order = Order.create(status: "pending")
      session[:order_id] = @order.id
    end

    @item = OrderItem.find_by(product_id: params[:id], order_id: session[:order_id])
    if @item.nil?
      @item = OrderItem.new(quantity: params[:quantity], product_id: params[:id], order_id: session[:order_id])
    else
      # only update quantity when product exists in current order
      @item.quantity += params[:quantity].to_i
    end

    if @item.save
      flash[:success] = "Successfully added item to your cart"
    else
      @item.errors.each do |column, message|
        flash[:warning] = message
      end
    end

    redirect_back fallback_location: '/'
  end

  def update
    if @item.nil?
      redirect_to show_cart_path
      return
    elsif @item.update(quantity: params[:quantity])
      flash[:success] = "Quantity successfully updated"
      redirect_to show_cart_path
      return
    else
      render :edit, status: :bad_request
      return
    end
  end

  def destroy
    if @item
      @item.destroy
      flash[:success] = "Successfully removed #{@item.product.name} from your cart"
      redirect_to show_cart_path
      return
    else
      head :not_found
      return
    end
  end

  private
  def find_item
    @item = OrderItem.find_by(id: params[:id])
  end
end