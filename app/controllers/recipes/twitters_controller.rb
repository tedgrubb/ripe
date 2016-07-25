class Recipes::TwittersController < ApplicationController
  
  def new
    @recipe = Recipe.find_by_id(params[:recipe_id])
    url = tiny_url(recipe_url(@recipe))
    content = @recipe.name
    tweet = "#{content} #{url}"
    uri = URI.parse("http://twitter.com/home")
    uri.query = {
      "status" => tweet,
      "source" => "It's Ripe"
    }.to_query
    redirect_to uri.to_s
  end
  
end