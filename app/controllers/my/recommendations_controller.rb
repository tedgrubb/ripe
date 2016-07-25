class My::RecommendationsController < ApplicationController
  before_filter :login_required
  def index
    @user_nav = :you
    @user = current_user
    @pantry_ingredients = @user.pantry.pantry_ingredients.find(:all, :order => 'created_at DESC', :limit => 6)
    @suggested_recipes = @user.pantry.available_recipes.paginate(:per_page => 10, :page => params[:page])
    @html_title = "Home"
    respond_to do |format|
      format.js
      format.html { render :action => "index" }
      format.iphone { render :action => "index", :layout => "iphone" }
    end
  end
end