class Users::GroceryListsController < ApplicationController
  before_filter :load_user, :set_nav_item
  
  def index
    @user_nav = :you
    @sub_nav_item = :grocery_list
    @grocery_list = @user.grocery_list # main list (created when user is created)
    @grocery_list_ingredients = @grocery_list.ingredients.find(:all, :order => "categories.name", :include => "categories")
    @grocery_list_categories = {}
    @grocery_list_ingredients.each do |ingredient|
      @grocery_list_categories[ingredient.categories.last] ||= []
      @grocery_list_categories[ingredient.categories.last] << ingredient
    end
    @html_title = "#{@user.possessive_name} Grocery List"
    respond_to do |format|
      format.html { render :action => "index", :layout => "users" }
      format.print { render :action => "index", :layout => "print" }
      format.iphone { 
        if current_user
          render :action => "index", :layout => "iphone" 
        else
          redirect_to new_session_path    
        end
      }
    end
  end
  
  def show
    @user_nav = :you
    @grocery_list = @user.grocery_lists.find(params[:id])
    @grocery_list_ingredients = @grocery_list.ingredients.find(:all, :order => "categories.name", :include => "categories")
    @grocery_list_categories = {}
    @grocery_list_ingredients.each do |ingredient|
      @grocery_list_categories[ingredient.categories.last] ||= []
      @grocery_list_categories[ingredient.categories.last] << ingredient
    end
    @html_title = "Your grocery list"
    render :action => "show", :layout => "users"
  end
  
  def new
    @grocery_list = GroceryList.new
  end
  
  def create
    @grocery_list = GroceryList.new(params[:grocery_list])

    respond_to do |format|
      if @grocery_list.save
        @user.grocery_lists << @grocery_list
        flash[:notice] = "#{@grocery_list.name} grocery list was created."
        format.html { redirect_to([@user, @grocery_list]) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @grocery_list.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @grocery_list = GroceryList.find(params[:id])

    respond_to do |format|
      if @grocery_list.update_attributes(params[:grocery_list])
        flash[:notice] = "#{@grocery_list.name} grocery list was updated."
        format.html { redirect_to(@grocery_list) }
        format.js do
          head 200
        end
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @grocery_list = GroceryList.find(params[:id])
    @grocery_list.destroy

    respond_to do |format|
      format.html { redirect_to(user_grocery_lists_path(@user)) }
      format.xml  { head :ok }
    end
  end
  
  private 
  
  def load_user
    @user = User.find(params[:user_id])
  end
  
  def set_nav_item
    @nav_item = :yours
  end

end
