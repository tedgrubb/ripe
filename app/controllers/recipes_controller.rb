class RecipesController < ApplicationController
  before_filter :set_nav_item
  before_filter :login_required, :only => :new
  helper IngredientsHelper

  def index
    order = params[:order].to_sym if params[:order]
    @sort_by = order || :created_at
    @order = @sort_by == :created_at ? "#{@sort_by} DESC" : @sort_by
    @category = params[:category] || nil
    if @category
      @recipes = Recipe.paginate :page => params[:page], :conditions => ["category = ? and published = ?", @category, true], :order => @order, :per_page => 12
    else
      @recipes = Recipe.paginate :page => params[:page], :conditions => ["published = ?", true], :order => @order, :per_page => 12
    end
    @user_nav = :recipes
    @html_title = "Recipes"
  end

  def show
    @user_nav = :recipes
    @recipe = Recipe.find(params[:id])
    @servings = @recipe.servings || nil
    @ingredients = @recipe.recipe_ingredients.find(:all, :include => :ingredient)
    @html_title = @recipe.name
    @recipe.views = @recipe.views.to_i + 1
    @recipe.save
    #@related_recipes = Recipe.find_by_solr(@recipe.name, :limit => 4).results
    @related_recipes = Recipe.find(:all, :conditions => "name like '%#{@recipe.name}%'")
    @related_recipes = @related_recipes - [@recipe]
    respond_to do |format|
      format.html { render :action => "show" }
      format.print { render :action => "show", :layout => "print" }
      format.json { render :text => @recipe.to_cooking_json}
    end
  end

  def new
    @user_nav = :recipes
    @recipe = Recipe.new
    @recipe_ingredients = []
    @steps = [Step.create]
    @html_title = "Add a new recipe"
    @flickr_photos = []
  end

  def edit
    @user_nav = :recipes
    @recipe = Recipe.find(params[:id])
    if current_user && current_user.can_edit_recipe(@recipe)
      @recipe_ingredients = @recipe.recipe_ingredients.find(:all, :include => "ingredient")
      @steps = Step.find_all_by_recipe_id(params[:id])
      @html_title = "Editing #{@recipe.name}"
    else 
      flash[:notice] = "You don't have permission to edit that recipe"
      redirect_to "/"
    end
  end

  def create
    params[:recipe]["published"] = params[:recipe]["published"].nil? ? false : true
    @recipe = Recipe.new(params[:recipe])
    respond_to do |format|
      if @recipe.save_with_associations
        flash[:notice] = 'Recipe was successfully created.'
        format.html { redirect_to(@recipe) }
      else
        @ingredients = Ingredient.find(:all)          
        format.html { render :action => "new" }
      end
    end
  end

  def update
    params[:recipe]["published"] = params[:recipe]["published"].nil? ? false : true
    @recipe = Recipe.find(params[:id])
    respond_to do |format|
      params[:recipe][:user_id] = @recipe.user_id
      @recipe.attributes = params[:recipe]
      if @recipe.save_with_associations
        flash[:notice] = 'recipe was successfully updated.'
        format.html { redirect_to(@recipe) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @recipe.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy

    respond_to do |format|
      format.html { redirect_to(recipes_url) }
      format.js { redirect_to(recipes_url) }
    end
  end
  
  def ingredient_list
    @recipe = Recipe.find(params[:id])
    @servings = params[:servings].to_i
    @ingredients = @recipe.recipe_ingredients.find(:all, :include => :ingredient)
    respond_to do |format|
      format.js
    end
  end
  
  def flickr_photos
    @recipe = Recipe.find(params[:id])
    flickr = Flickr.new("#{RAILS_ROOT}/config/flickr.yml")
    @flickr_photos = flickr.photos.search(:text => "#{URI.escape(@recipe.name.split(" ").join(","))}", :sort => "relevance", :per_page => 18)
    respond_to do |format|
      format.js
    end
  end

  def random
    @recipe = Recipe.find(:first, :conditions => ["published = ?", true], :order => "RAND()", :limit => 1)
    redirect_to(@recipe)
  end

  private 

  def set_nav_item
    @nav_item = :recipes
  end
end
