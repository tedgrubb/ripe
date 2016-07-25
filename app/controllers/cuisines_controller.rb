class CuisinesController < ApplicationController
  
  def create
    @cuisine = Cuisine.new(params[:cuisine])
    @cuisine.save!
  end
  
  def show
    @cuisine = Cuisine.find(params[:id])
    order = params[:order].to_sym if params[:order]
    @sort_by = order || :created_at
    @order = @sort_by == :created_at ? "#{@sort_by} DESC" : @sort_by
    @category = params[:category] || nil
    if @category
      @recipes = @cuisine.recipes.paginate :page => params[:page], :conditions => ["category = ? and published = ?", @category, true], :order => @order, :per_page => 12
    else
      @recipes = @cuisine.recipes.paginate :page => params[:page], :conditions => ["published = ?", true], :order => @order, :per_page => 12
    end
    @html_title = "#{@cuisine.name} Recipes"
    respond_to do |format|
      format.html {render :action => "show", :layout => "recipes"}
      format.rss {}
    end
  end
  
end