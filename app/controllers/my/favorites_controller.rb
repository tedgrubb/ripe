class My::FavoritesController < ApplicationController
  before_filter :login_required, :load_user
  def index
    @user_nav = :home
    
    @favorite_recipes = @user.favorite_recipes
    @html_title = "My favorite recipes"
    respond_to do |format|
      format.js

      format.html { render :action => "index" }
      format.iphone { render :action => "index", :layout => "iphone" }
    end
  end
end