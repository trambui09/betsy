class ApplicationController < ActionController::Base
  def current_merchant
    @current_merchant = Merchant.find_by(id: session[:merchant_id]) if session[:merchant_id]
  end
end
