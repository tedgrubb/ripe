#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/../config/environment'
require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'pp'
 
@url = "http://www.epicurious.com/recipes/food/views/Breakfast-Couscous-with-Dried-fruit-compote-350221"
@response = ''

open(@url) { |input|
  @response = input.read
}

doc = Hpricot(@response)
recipe = {}
recipe[:title] = (doc/"//*[@id='headline']/h1").inner_html
recipe[:description] = (doc/"//*[@id='recipe_intro']/p").inner_html
recipe[:servings] = (doc/"//*[@class='summary_data']").first.inner_html
recipe[:time] = (doc/"//*[@class='summary_data']").last.inner_html
recipe[:ingredients] = []
(doc/"//*[@id='ingredientsList']/li").each_with_index do |ingredient, i|
  recipe[:ingredients][i] = "#{ingredient.inner_html}"
end

puts recipe[:title]
puts recipe[:description]
puts recipe[:servings]
puts recipe[:time]
puts recipe[:ingredients]


