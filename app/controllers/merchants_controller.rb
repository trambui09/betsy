class MerchantsController < ApplicationController

  def show
    @merchant = Merchant.find_by_id(params[:id])

    if @merchant.nil?
      redirect_to merchants_path
      return
    end

    @products = @merchant.products
  end

  def new
    @merchant = Merchant.new
  end

  def index
    @merchants = Merchant.all
  end
end
