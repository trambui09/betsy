class ProductsController < ApplicationController

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    merchant = if params[:merchant_id]
                 Merchant.find_by(id: params[:merchant_id])
               elsif params[:product][:merchant_id]
                 Merchant.find_by(id: params[:product][:merchant_id])
               end

    @product = merchant.products.new(product_params)
    # @product.default
    if @product.save
      if params[:merchant_id]
      flash[:success] = "Successfuly created #{@product.category} #{@product.id}"
      redirect_to merchant_product_path(id: @product.id)
      else
        redirect_to product_path(@product.id)
      end
      return
    else
      render :new, status: :bad_request
      return
    end
  end

  def destroy
    product_id = params[:id]
    @product = Product.find_by(id: product_id)

    if @product
      @product.destroy
      if params[:merchant_id]
        redirect_to merchant_path(params[:merchant_id])
      else
        redirect_to products_path
      end
    else
      head :not_found
      return
    end
  end

  private

  def product_params
    return params.require(:product).permit(:name, :price, :description, :photo_url, :inventory_stock, :merchant_id)
  end
end
