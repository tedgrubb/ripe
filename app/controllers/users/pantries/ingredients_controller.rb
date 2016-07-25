class Users::Pantries::IngredientsController < ApplicationController

  before_filter :load_user, :load_pantry

  def create
    @ingredient = Ingredient.find_by_id(params[:pantry_ingredient]['ingredient_id'])
    @pantry.ingredients.delete(@ingredient)
    @pantry_ingredient = @pantry.pantry_ingredients.build(params[:pantry_ingredient])
    if @pantry_ingredient.save
      respond_to do |format|
        format.js
      end
    else
      flash[:notice] = 'Failed to add this ingredient to your pantry.'
    end
  end
  
  def destroy
    @ingredient = Ingredient.find_by_id(params[:id])
    @pantry.ingredients.delete(@ingredient)
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
          @results = Ingredient.find(:all, :conditions => "name like '%#{@query}%'", :limit => 10)          
        else
          @results = []
          @count = 0
        end
      end
    end
  end
  
  def insert
    @ingredient = Ingredient.find(params[:id])
    ActiveRecord::Base.transaction do
      @user.pantry.ingredients.delete(@ingredient)
      @user.pantry.ingredients << @ingredient
    end
    @pantry_ingredient = @user.pantry.pantry_ingredients.last
    respond_to do |format|
      format.js
    end
  end
  
  private
  
  def load_user
    @user = User.find(params[:user_id])
  end
  
  def load_pantry
    @pantry = @user.pantry
  end
end
