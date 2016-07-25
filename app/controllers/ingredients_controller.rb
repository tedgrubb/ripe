class IngredientsController < ApplicationController
  before_filter :load_all_categories, :only => [:index, :show]
  before_filter :set_nav
  layout 'ingredients'

  def index
    @user_nav = :ingredients
    @html_title = "Explore all ingredients"
    order = params[:order].to_sym if params[:order]
    @sort_by = order || :popular
    if @sort_by == :popular
      @ingredients = Ingredient.paginate :page => params[:page], 
      :select => 'ingredients.*, count(recipe_ingredients.id) as recipe_usage', 
      :order => 'recipe_usage DESC',
      :joins => 'LEFT OUTER JOIN recipe_ingredients on recipe_ingredients.ingredient_id = ingredients.id',
      :group => 'ingredients.id'
    elsif @sort_by == :name
      @ingredients = Ingredient.paginate :page => params[:page], :order => :name
    end
  end

  def show
    @user_nav = :ingredients
    respond_to do |format|
      @ingredient = Ingredient.find(params[:id])
      @recipes = @ingredient.recipes.paginate :page => params[:page], :conditions => ["published = ?", true], :per_page => 12
      format.html {
        @categories = @ingredient.categories.find(:all)
        @html_title = "#{@ingredient.name}"
      }
      format.iphone {
        @iphone_title = @ingredient.name
        render :action => "show", :layout => "iphone"
      }
    end
  end
  
  def new
    @ingredient = Ingredient.new
    @categories = Category.find(:all, :order => "name")
    @html_title = "Add a new ingredient"
  end

  def edit
    @ingredient = Ingredient.find(params[:id], :include => :categories)
    if current_user && current_user.can_edit_ingredient(@ingredient)
      @categories = Category.find(:all, :order => "name")
      @html_title = "Editing #{@ingredient.name}"
    else
      flash[:notice] = "You don't have permission to edit that ingredient"
      redirect_to "/"
    end
  end

  def create
    @ingredient = Ingredient.new(params[:ingredient])
    
    respond_to do |format|
      if @ingredient.save_with_categories
        flash[:notice] = 'Ingredient was successfully created.'
        format.html { redirect_to(@ingredient) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @ingredient = Ingredient.find(params[:id])

    respond_to do |format|
      @ingredient.attributes = params[:ingredient]
      if @ingredient.save_with_categories
        flash[:notice] = 'Ingredient was successfully updated.'
        format.html { redirect_to(@ingredient) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
    @ingredient = Ingredient.find(params[:id])
    @ingredient.destroy

    respond_to do |format|
      format.html { redirect_to(ingredients_url) }
      format.js
    end
  end
  
  def search
    @query = params[:query]
    respond_to do |format|
      format.js do
        if @query
          #@solr_docs = Ingredient.find_by_solr(@query)
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

  def random
    @ingredient = Ingredient.find(:first, :order => "RAND()", :limit => 1)
    redirect_to(@ingredient)
  end
  
  private
  
  def set_nav
    @nav_item = :ingredients
  end
  
  def load_all_categories
    #TODO: I got this warning in the log
    #/Users/TedGrubb/src/grocery/app/controllers/ingredients_controller.rb:107: warning: string literal in condition
    @all_categories = Category.find(:all, :order => "name")
  end
  
end
