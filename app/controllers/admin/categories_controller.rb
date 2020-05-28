class Admin::CategoriesController < ApplicationController
  def index
    @categories = Category.order(id: :desc).all
  end

  def create
  end

  def new
  end

  def show
  end
end
