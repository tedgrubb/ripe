#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../config/environment'
require 'pp'
require 'scraper_helpers'
include ScraperHelpers

class RecipeImporter
  def self.init(import_source)
    @import_source = import_source
    if @import_source
      self.run
    else
      print "ERROR: No recipe source was given!\n"
      print "Quitting...\n"
    end
  end
  
  def self.test
    p @import_source
  end
  
  def self.run
    print "Importing recipes from #{Rails.root}/db/data/recipes/#{@import_source}...\n"
    recipes_raw = IO.read("#{Rails.root}/db/data/recipes/#{@import_source}")
    recipes = self.parse recipes_raw
    attributes = recipes.map do |r|
       import_content = r
       r = r.compact
       length = r.length-2
       next if length == -2
       {
         :name => r[0].to_s.split("--")[1],
         :steps => r.last.split(".  "),
         :ingredients => r.slice!(1, length),
         :import_content => import_content
       }
     end
     
     attributes.each do |attr|
       begin
         recipe = {}
         #recipe[:user_id] = 71 # SwedishChef
         recipe[:user_id] = 5 # Ted (LOCAL)
         recipe[:name] = attr[:name].lstrip.humanize.squeeze(" ")
         #recipe[:description] = ""
         #recipe[:uploaded_data] = ""
         #recipe[:servings] = ""
         recipe[:published] = false
         recipe[:import_source] = "text"
         recipe[:import_content] = attr[:import_content]
     
         recipe[:new_ingredients] = {}
         recipe[:new_ingredients]['ingredient_id'] = []
         recipe[:new_ingredients]['entered_quantity'] = []
         recipe[:new_ingredients]['measurement'] = []
         recipe[:new_ingredients]['note'] = []
         attr[:ingredients].each do |i|
           recipe[:new_ingredients]['ingredient_id'] << ScraperHelpers::find_or_create_ingredient(i)
           recipe[:new_ingredients]['entered_quantity'] << ScraperHelpers::parse_quantity(i)
           recipe[:new_ingredients]['measurement'] << ScraperHelpers::parse_measurement(i)
           recipe[:new_ingredients]['note'] << ScraperHelpers::parse_note(i)
         end
     
         recipe[:new_steps] = {}
         recipe[:new_steps]['number'] = []
         recipe[:new_steps]['uploaded_data'] = []
         recipe[:new_steps]['description'] = []
         attr[:steps].each_with_index do |step, i|
           recipe[:new_steps]['number'] << "#{i}"
           recipe[:new_steps]['uploaded_data'] << ""
           recipe[:new_steps]['description'] << "#{step}"
         end
     
         new_recipe = Recipe.new(recipe)
         new_recipe.save_with_associations!
         print "IMPORTED: #{recipe[:name]}\n"
       rescue
         print "FAILED: #{recipe[:name]}\n"
       end
     end
  end
  

  def self.parse(string)
    string.split("------------------------").map do |group|
      split = group.split("\n")
      translated = split.map do |value|
        case value
        when "\r" then nil
        else value.gsub(/\r/, "")
        end 
      end
    end
  end
end
