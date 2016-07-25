class RootController < ApplicationController
  skip_before_filter :login_required
  layout 'root'
  def index
    @nav_item = :home
    if current_user
      redirect_to my_home_path
    else
      @logged_out_home = true
      logged_out_home
    end
  end
  
  private
  
  def logged_in_home
    @user = current_user
    @pantry_ingredients = @user.pantry.pantry_ingredients.find(:all, :order => 'created_at DESC', :limit => 6)
    @suggested_recipes = @user.pantry.available_recipes.paginate(:per_page => 10, :page => params[:page])
    @html_title = "What's cookin' #{@user.name}?"
    respond_to do |format|
      format.html { render :action => "index" }
      format.iphone { redirect_to(user_grocery_lists_path(@user)) }
    end
  end
  
  def logged_out_home
    respond_to do |format|
      format.html { 
        @featured_recipes = Recipe.find(:all, :conditions => ['photos.id IS NOT NULL', true], :include => [:photo], :order => "created_at DESC", :limit => 6)
        #@new_users = User.find(:all, :order => "created_at DESC", :limit => 5)
        @invite_request = InviteRequest.new()
        @html_title = "Recipes you can make with the ingredients you've got."
        render :action => "index" 
      }
      format.iphone { redirect_to(new_session_path) }
    end
  end
  
end