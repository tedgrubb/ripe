class Users::GroceryLists::IngredientsController < ApplicationController

  before_filter :load_user, :load_grocery_list

  def create
    load_grocery_list
    @ingredient = Ingredient.find_by_id(params[:grocery_list_ingredient]['ingredient_id'])
    @grocery_list.ingredients.delete(@ingredient)
    @grocery_list_ingredient = @grocery_list.grocery_list_ingredients.build(params[:grocery_list_ingredient])
    if @grocery_list_ingredient.save
      respond_to do |format|
        format.js { 
          if params[:from_search]
            render :action => "insert"
          end
          }
      end
    else
      flash[:notice] = 'Failed to add this ingredient to your grocery list.'
    end
  end
  
  def checked_off
    @ingredient = Ingredient.find(params[:id])
    ActiveRecord::Base.transaction do
      @user.pantry.ingredients.delete(@ingredient)
      @user.pantry.ingredients << @ingredient
    end
    respond_to do |format|
      format.js
    end
  end
  
  def add_recipe
    @recipe = Recipe.find(params[:recipe_id])
    @to_add = (@recipe.ingredients - @user.pantry.ingredients)
    @grocery_list.ingredients |= @to_add
  end
  
  def destroy
    load_grocery_list
    @ingredient = Ingredient.find_by_id(params[:id])
    @grocery_list.ingredients.delete(@ingredient)

    respond_to do |format|
      format.js
    end
  end
  
  def search
    @query = params[:query]
    @offset = params[:offset] ? params[:offset].to_i : 0
    respond_to do |format|
      format.js do
        if @query
          # @solr_docs = Ingredient.find_by_solr(@query, :limit => 5, :offset => @offset)
          # @results = @solr_docs.results
          @results = Ingredient.find(:all, :conditions => "name like '%#{@query}%'")
        else
          @results = []
          @count = 0
        end
      end
    end
  end
  
  def insert
    @ingredient = Ingredient.find(params[:id])
    respond_to do |format|
      format.js
    end
  end
  
  private
  
  def load_user
    @user = User.find(params[:user_id])
  end
  
  def load_grocery_list
    @grocery_list = @user.grocery_list
  end
  
end
