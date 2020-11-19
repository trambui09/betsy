class CategoriesController < ApplicationController

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

  def edit
    @category = Category.find_by(id: params[:id])
    if @category.nil?
      head :not_found
      return
    end
  end

  def update

  end



  private
  def category_params
    return params.require(:category).permit(:category_id, :name)
  end
end
