#!/usr/bin/env ruby
ENV["RAILS_ENV"] ||= "production"
require File.dirname(__FILE__) + '/../config/environment'
require 'rubygems'
require 'twibot'
include ActsAsTinyUrl

reply do |message, params|
  if message.text.match("I have") != nil
    ingredients = []
    twingredients = message.text.gsub("I have", "").split(",")
    twingredients.each do |twingredient|
      solr_search = Ingredient.find_by_solr(Ingredient.clean_solr(twingredient))
      ingredients << solr_search.results.first unless solr_search.total == 0
    end
    if ingredients.any?
      recipe    = Recipe.for_ingredients(ingredients).first
      url       = tiny_url("http://itsripe.com/recipes/#{recipe.id}")
      response  = "@#{message.user.screen_name} Make #{recipe.name} - #{url}"
    else
      response  = "@#{message.user.screen_name} Couldn't find anything this time. Feeling lucky? http://itsripe.com/recipes/random"
    end
    post_tweet response
  end
end
