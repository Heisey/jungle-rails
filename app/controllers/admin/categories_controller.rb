class Admin::CategoriesController < ApplicationController
  def index
    @categories = Category.order(id: :desc).all
  end

  def create
    @category = Category.new(categrory_params)

    if @category.save
      redirect_to [:admin, :categories], notice: 'Category created!'
    else
      render :new
    end
  end

  def new
    @category = Category.new
  end

  def show
  end

  def categrory_params
    params.require(:category).permit(:name)
  end
end
