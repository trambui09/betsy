class ApplicationController < ActionController::Base
  before_action :current_merchant
  before_action :current_order
  before_action :all_categories

  def current_merchant
    @current_merchant = Merchant.find_by(id: session[:merchant_id]) if session[:merchant_id]
  end

  def current_order
    @current_order = Order.find_by(id: session[:order_id]) if session[:order_id]
  end

  def all_categories
    @categories = Category.all
  end

  def require_login
    if @current_merchant.nil?
      flash[:danger] = "You must be logged in to do that"
      redirect_to root_path
      return
    end
  end

  def require_cart
    if @current_order.nil?
      flash[:danger] = "You must have a cart in session"
      redirect_to root_path
      return
    end
  end
end
