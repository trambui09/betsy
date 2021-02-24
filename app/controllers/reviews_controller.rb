class ReviewsController < ApplicationController

  before_action :find_product

  def index
    @product = Product.find(params[:product_id])
  end

  def new
    # @review = Review.new
    merchant = @current_merchant

    if merchant.products.include?(@product)
      flash[:warning] = "You can't review your own product!"
      redirect_to product_path(@product)
    else
      @review = Review.new
    end

  end

  def create
    # nested reviews inside product
    # similar to merchant having many products create controller action
    @review = @product.reviews.new(review_params)

    if @review.save
      flash[:success] = 'Review was successfully created.'
      redirect_to product_path(@product)
    else
      @review.errors.each do |column, message|
        flash.now[:warning] = "A problem occurred: Could not create review #{column}: #{message}"
      end
      render :new, status: :bad_request
      return
    end

  end

  private
  def review_params
    return params.require(:review).permit(:rating, :description)
  end

  def find_product
    @product = Product.find(params[:product_id])
  end

  def find_review
    @review = product.reviews.find(params[:id])
  end
end
