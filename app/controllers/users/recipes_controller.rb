class Users::RecipesController < ApplicationController
  before_filter :load_user
  
  def index
    @user_nav = :you
    @sub_nav_item = :recipes
    order = params[:order] || "created_at DESC"
    @recipes = Recipe.find_all_by_user_id(@user, :order => order).paginate :page => params[:page], :per_page => 12
    respond_to do |format|
      format.html { render :action => "index", :layout => "users" }
      format.iphone { render :action => "index", :layout => "iphone" }
      format.rss
    end
  end
  
  private
  
  def load_user
    @user = User.find(params[:user_id])
  end
end