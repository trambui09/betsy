class OrdersController < ApplicationController
  # def index
  #   @order = Order.all
  # end

  def show
    @order = Order.find_by(id: params[:id])
    if @order.nil?
      head :not_found
    end
  end

  def new
    @order = Order.new(status: "pending")
  end

  def create

    @order = Order.new(order_params)

    if @order.save
      @order.status = "paid"
      flash[:success] = "Successfully created Order ##{@order.id}"
      redirect_to order_path(@order.id)
      return
    else
      flash.now[:danger] = "Failed to create order"
      render :new, status: :bad_request
      return
    end
  end

  def update
    @order = Order.find_by(id: params[:id])
    # @order.status = "cancelled"
    # Order quantity
    if @order.nil?
      flash[:error] ="Something went wrong, contact merchant"
      redirect_to root_path
    elsif @order.update(order_params)
      flash[:success]= "You have successfully updated #{@order.id}"
      redirect_to order_path(@order)
      return
    else
      render :edit, status: :bad_request
      return
      end
  end

  #Maybe using Update to change status of order as cancelled?
  #
  def destroy
    if @order
      @order.destroy
      @order.status = "cancelled"
      flash[:success] = "Successfully cancelled Order ##{@order.id}"
      redirect_to root_path
      return
    else
      head :not_found
      return
    end
  end

  private
  def order_params
    return params.require(:order).permit(:name, :address, :email, :credit_card_num, :exp_date, :cvv, :billing_zip)
  end
end

