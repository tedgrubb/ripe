class SearchesController < ApplicationController
  layout 'recipes'
  
  def index
    @nav_item = :recipes
    @query = params[:query]
    respond_to do |format|
      format.html do
        do_search
        render :action => 'index'
      end
      format.js do
        do_search
      end
    end
  end
  
  def do_search
    if @query
      # @solr_docs = Recipe.find_by_solr(@query)
      # @results = @solr_docs.results
      # @count = @solr_docs.total
      @results = Recipe.find(:all, :conditions => "name like '%#{@query}%'")
      @count = @results.length
    else
      @query = ""
      @results = []
      @count = 0
    end
  end
end
