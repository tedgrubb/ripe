#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/../config/environment'
require 'pp'

def parse(string)
  string.split("\r\n").map do |line|
    split = line.split("^")

    translated = split.map do |value|
      case value
      when /~(.*)~/ then $1
      when /(\d+)/ then $1.to_i 
      when '' then nil
      else raise "asplode: #{value}"
      end
    end
  end
end

food_groups_raw = IO.read("#{Rails.root}/db/data/nutridb/FD_GROUP.txt")
food_groups = Hash[*parse(food_groups_raw).flatten]

descriptions_raw = IO.read("#{Rails.root}/db/data/nutridb/FOOD_DES.txt")

descriptions = parse descriptions_raw
attributes = descriptions.map do |d|
  {
    :name => d[2],
    :ndb_id => d[0],
    :food_group => food_groups[d[1]] 
  }
end

attributes.each do |attr|
  ingredient = Ingredient.new(attr)
  ingredient.save_with_categories!
end




