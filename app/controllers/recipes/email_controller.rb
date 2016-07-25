class Recipes::EmailController < ApplicationController
  def new
    @recipe = Recipe.find_by_id(params[:recipe_id])
  end
  def show
    @recipe = Recipe.find_by_id(params[:recipe_id])
    RecipeMailer.deliver_share_recipe(params)
  end
end