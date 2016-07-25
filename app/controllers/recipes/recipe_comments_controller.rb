class Recipes::RecipeCommentsController < ApplicationController
  
  def create
    @recipe = Recipe.find_by_id(params[:recipe_id])
    @comment = @recipe.recipe_comments.create(:user_id => current_user.id, :comment => params[:comment])
  end
  
  def destroy
    @recipe = Recipe.find_by_id(params[:recipe_id])
    @comment = @recipe.recipe_comments.find_by_id(params[:id])
    @comment.destroy
    respond_to do |format|
      format.html
      format.js
    end
  end
  
end