class CategoriesController < ApplicationController
  before_filter :load_all_categories, :only => [:index, :show]
  layout 'ingredients'

  def index
    @categories = Category.find(:all)
    @nav_item = :ingredients
    respond_to do |format|
      format.html
    end
  end

  def show
    @category = Category.find(params[:id])
    @nav_item = :ingredients
    order = params[:order].to_sym if params[:order]
    @sort_by = order || :popular
    if @sort_by == :popular
      @ingredients = @category.ingredients.paginate :page => params[:page], 
      :select => 'ingredients.*, count(recipe_ingredients.id) as recipe_usage', 
      :order => 'recipe_usage DESC',
      :joins => 'LEFT OUTER JOIN recipe_ingredients on recipe_ingredients.ingredient_id = ingredients.id',
      :group => 'ingredients.id'
    elsif @sort_by == :name
      @ingredients = @category.ingredients.paginate :page => params[:page], :order => :name
    end
    render :action => :show, :layout => "ingredients"
  end

  def new
    @category = Category.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def create
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        flash[:notice] = 'Category was successfully created.'
        format.html { redirect_to(@category) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @category = Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        flash[:notice] = 'Category was successfully updated.'
        format.html { redirect_to(@category) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to(categories_url) }
    end
  end
  
  
  private
  
  def load_all_categories
    @all_categories = Category.find(:all, :order => "name")
  end
end
