class Recipes::RecipeRatingsController < ApplicationController
  
  def create
    @recipe = Recipe.find_by_id(params[:recipe_id])
    @existing_rating = @recipe.recipe_ratings.find_by_user_id(current_user.id)
    if @existing_rating 
      @recipe.recipe_ratings.delete(@existing_rating)
    end
    @recipe.recipe_ratings.create(:user_id => current_user.id, :score => params[:score])
  end
  
  def destroy
    
  end
  
end