class My::GroceriesController < ApplicationController
  before_filter :load_user, :login_required

  def index
    @user_nav = :you
    @html_title = "My Groceries"
    @grocery_list = @user.grocery_list # main list (created when user is created)
    @grocery_list_ingredients = @user.grocery_list.ingredients.find(:all, :order => "categories.name", :include => "categories")
    @grocery_list_categories = {}
    @grocery_list_ingredients.each do |ingredient|
      @grocery_list_categories[ingredient.categories.last] ||= []
      @grocery_list_categories[ingredient.categories.last] << ingredient
    end
    respond_to do |format|
      format.html { render :action => "index", :layout => "users" }
      format.print { render :action => "index", :layout => "print" }
      format.iphone { 
        @iphone_title = "Groceries"
        render :action => "index", :layout => "iphone" 
      }
    end    
  end

private

  def load_user
    @user = current_user
  end

end