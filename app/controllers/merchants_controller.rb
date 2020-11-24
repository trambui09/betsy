class MerchantsController < ApplicationController
  # skip_before_action :require_login, except: [] for actions that guests can view (homepages#index, login page)
  before_action :require_login, only: [:show]
  def index
    @merchants = Merchant.all
  end
  def show
    @merchant = Merchant.find_by_id(params[:id])

    if @merchant.nil?
      redirect_to merchants_path
      return
    end

    @products = @merchant.products
  end

  def create
    auth_hash = request.env["omniauth.auth"]
    merchant = Merchant.find_by(uid: auth_hash[:uid], provider: auth_hash[:provider])
    if merchant
      # User was found in the database
      flash[:success] = "Logged in as returning merchant #{merchant.username}"
    else
      # User doesn't match anything in the DB
      merchant = Merchant.build_from_github(auth_hash)

      if merchant.save
        flash[:success] = "Logged in as new merchant #{merchant.username}"
      else
        # Couldn't save the user for some reason. If we
        # hit this it probably means there's a bug with the
        # way we've configured GitHub. Our strategy will
        # be to display error messages to make future
        # debugging easier.
        flash[:warning] = "Could not create new merchant account: #{merchant.errors.messages}"
        redirect_to root_path
        return
      end
    end

    # If we get here, we have a valid user instance
    session[:merchant_id] = merchant.id
    redirect_to root_path
    return
  end

  def logout
    session[:merchant_id] = nil
    flash[:success] = "Successfully logged out"

    redirect_to root_path
    return
  end
end
