class CategoriesController < ApplicationController

  before_action :require_login, only: [:new, :create]

  def index
    @categories = Category.all
  end

  def show
    @category = Category.find_by(id: params[:id])
    if @category.nil?
      head :not_found
      return
    end
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    # @category.name = "food"
    if @category.save
      flash[:success] = "Succesfully created #{@category.name} category"
      redirect_to category_path(@category.id)
    else
      @category.errors.each do |column, message|
        flash.now[:warning] = "A problem occurred: Could not create #{@category.name} #{column}: #{message}"
      end
      render :new, status: :bad_request
      return
    end
  end

  # TODO: don't think we need edit and update category
  # def edit
  #   @category = Category.find_by(id: params[:id])
  #   if @category.nil?
  #     head :not_found
  #     return
  #   end
  # end

  # def update
  #   @category = Category.find_by(id: params[:id])
  #
  #   if @category.nil?
  #     head :not_found
  #     return
  #   elsif @category.update(category_params)
  #     redirect_to categories_path(@category)
  #     return
  #   else
  #     render :bad_request
  #     return
  #   end
  # end

  private
  def category_params
    return params.require(:category).permit(:category_id, :name)
  end
end
