class My::PantryController < ApplicationController
  before_filter :load_user, :login_required
  layout "users"
  def show
    @user_nav = :you
    @html_title = "My Pantry"
    @pantry = @user.pantry
    respond_to do |format|
      format.html { 
        @ingredients = @pantry.pantry_ingredients.paginate :page => params[:page], :order => "expires_at ASC",  :limit => 10
        render :action => "show"
      }
      format.iphone {
        @iphone_title = "Pantry"
        @ingredients = @pantry.pantry_ingredients.find(:all)
        @ingredient_categories = {}
        @ingredients.each do |pantry_ingredient|
          @ingredient_categories[pantry_ingredient.ingredient.categories.last] ||= []
          @ingredient_categories[pantry_ingredient.ingredient.categories.last] << pantry_ingredient
        end
        render :action => "show", :layout => "iphone" 
      }
    end
  end
  
end