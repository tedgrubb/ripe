class Users::SetupController < ApplicationController
  before_filter :load_user
  before_filter :login_required
  layout 'users'
  
  def show 
    @html_title = "Welcome! Let's get you set up."
    @cuisines = Cuisine.find(:all, :order => "name")
  end
  
  def ingredients
    @cuisines = Cuisine.all
    @cuisine_array = @user.cuisines.map {|c| c.id}
    @recipe_cuisines = RecipeCuisine.find(:all, :conditions => {:cuisine_id => @cuisine_array})
    @recipe_array = @recipe_cuisines.map {|rc| rc.recipe.id}
    @recipe_ingredients = RecipeIngredient.find(:all, :conditions => {:recipe_id => @recipe_array})
    @ingredients = @recipe_ingredients.map {|ri| ri.ingredient}
    @ingredients = @ingredients.uniq    
  end
  
  def update
    @cuisines = params[:user][:cuisine_preferences] || []
    @user.cuisine_preferences.destroy_all
    if @cuisines.any?
      @cuisines.each do |pair|
        cuisine = pair[0]
        CuisinePreference.create!(:user => @user, :cuisine_id => cuisine)
      end
    end
    respond_to do |format|
      if @user.update_attributes(params[:user])
        if @user.cuisines.blank?
          format.html { redirect_to("/") }
        else
          format.html { redirect_to(ingredients_user_setup_path(@user)) }          
        end
      else
        flash[:notice] = 'There was a problem saving your settings'  
        format.html { redirect_to(user_setup_path(@user)) }
      end
    end
  end
  
  private
  
  def load_user
    @user = User.find(params[:user_id])
  end
  
end
