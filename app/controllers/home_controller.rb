class HomeController < ApplicationController
  before_filter :login_required
  def show
    @user = current_user
    @pantry_ingredients = @user.pantry.pantry_ingredients.find(:all, :order => 'created_at DESC', :limit => 6)
    @suggested_recipes = @user.pantry.available_recipes.paginate(:per_page => 10, :page => params[:page])
    @html_title = "Home"
    respond_to do |format|
      format.html { render :action => "show" }
      format.iphone { redirect_to(user_grocery_lists_path(@user)) }
    end
  end
end