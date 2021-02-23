class ReviewsController < ApplicationController

  before_action :find_product

  def index
    @product = Product.find(params[:product_id])
  end
  def new
    # @review = Review.new

    @review = Review.new
  end

  def create
    # @review = Review.new(review_params)
    # if @review.save
    #   flash[:success] = "Successfully added your review"
    #   # TODO: redirect to product show page, how to find the product id?
    #   redirect_to product_path(@product)
    # else
    #   @review.errors.each do |column, message|
    #     flash.now[:warning] = "A problem occurred: Could not create review #{column}: #{message}"
    #   end
    #   render :new, status: :bad_request
    #   return
    # end


    @review = Review.new
    @review.product_id = @product.id

    if @review.save
      flash[:notice] = 'Review was successfully created.'
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
