class ApplicationController < ActionController::Base
  before_action :require_login

  def current_merchant
    return Merchant.find_by(id: session[:merchant_id]) if session[:merchant_id]
  end

  def require_login
    if current_merchant.nil?
      flash[:error] = "You must be logged in to do that"
      redirect_to root_path
      return
    end
  end
end
