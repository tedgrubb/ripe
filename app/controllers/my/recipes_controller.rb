class My::RecipesController < ApplicationController
  before_filter :load_user, :login_required

  def index
    @user_nav = :you
    @html_title = "My Recipes"
    order = params[:order] || "created_at DESC"
    @recipes = Recipe.find_all_by_user_id(@user, :conditions => ["published = ?", true], :order => order).paginate :page => params[:page], :per_page => 12
    
    respond_to do |format|
      format.html {
        render :action => "index"
      }
      format.iphone {
        @iphone_title = "Recipes"
        render :action => "index", :layout => "iphone" 
      }
    end
  end
  
private

  def load_user
    @user = current_user
  end
  
end