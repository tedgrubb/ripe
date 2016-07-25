class Recipes::MakeController < ApplicationController
  skip_before_filter :login_required
  def show
    @recipe = Recipe.find_by_id(params[:recipe_id])
  end
end