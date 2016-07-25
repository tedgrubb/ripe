#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/../config/environment'
require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'pp'
require 'scraper_helpers'
include ScraperHelpers


# CHOW IMPORT SPECIFICS

@id = "13650"
@url = "http://www.chow.com/recipes/#{@id}"
@response = ''

open(@url) { |input|
  @response = input.read
}

doc = Hpricot(@response)
recipe = {}
recipe[:user_id] = 5
recipe[:name] = (doc/"#title h1").inner_html
recipe[:description] = (doc/"//*[@id='intro_full']").inner_html
#recipe[:uploaded_data] = (doc/"/html/body/div/div[3]/div/div/div/div/div/div[3]/div/div[3]/img").first.attributes['src']
recipe[:servings] = (doc/"//*[@id='servings']/p").last.inner_html.match(/[*0-9]/)[0].to_i
recipe[:published] = false
recipe[:new_ingredients] = {}
recipe[:new_ingredients]['ingredient_id'] = []
recipe[:new_ingredients]['entered_quantity'] = []
recipe[:new_ingredients]['measurement'] = []
recipe[:new_ingredients]['note'] = []

(doc/"//*[@id='ingredients']/ul/li").each do |li|
  ingredient = (li/'/a').inner_html.downcase
  li = li.inner_html
  ingredient ||= li
  recipe[:new_ingredients]['ingredient_id'] << ScraperHelpers::find_or_create_ingredient(ingredient)
  recipe[:new_ingredients]['entered_quantity'] << ScraperHelpers::parse_quantity(li)
  recipe[:new_ingredients]['measurement'] << ScraperHelpers::parse_measurement(li)
  recipe[:new_ingredients]['note'] << ""
end

recipe[:new_steps] = {}
recipe[:new_steps]['number'] = []
recipe[:new_steps]['uploaded_data'] = []
recipe[:new_steps]['description'] = []
(doc/"//*[@id='instructions']/ol/li").each_with_index do |instruction, i|
  recipe[:new_steps]['number'] << "#{i}"
  recipe[:new_steps]['uploaded_data'] << ""
  recipe[:new_steps]['description'] << "#{instruction.inner_html}"
end

new_recipe = Recipe.new(recipe)
new_recipe.save_with_associations!
pp new_recipe
