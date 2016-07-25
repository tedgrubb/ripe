class Recipes::FavoriteRecipesController < ApplicationController
  
  def create
    unless FavoriteRecipe.find_by_recipe_id(params[:recipe_id])
      @favorite_recipe = FavoriteRecipe.create(:recipe_id => params[:recipe_id], :user_id => current_user.id)
      if @favorite_recipe.save
        respond_to do |format|
          format.js
        end
      end
    else
      @favorite_recipe = false
      respond_to do |format|
        format.js
      end
    end
  end
  
  def destroy
    
  end
  
end