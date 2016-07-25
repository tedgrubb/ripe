class My::HomeController < ApplicationController
  before_filter :load_user, :login_required
  layout "users"
  def show
    @user_nav = :you
    @html_title = "My Dashboard"
    @pantry = @user.pantry
    @friend_requests = User.find(:all, :order => "created_at DESC", :limit => 3)
    respond_to do |format|
      format.html { 
        @expired_ingredients = @pantry.expired_ingredients
        @ripe_pantry_ingredients = @pantry.pantry_ingredients.find(:all, :order => "expires_at DESC", :limit => 8)
        @grocery_list_ingredients = @user.grocery_list.ingredients.find(:all)
        render :action => "show" 
      }
    end
  end

private
end
