module ScraperHelpers

  def find_or_create_ingredient(li)
    sections = li.split(", ")
    if sections.length > 1
      sections.pop()
      li = sections.join(" ")
    end
    ingredient = scrub_line(li)
    ingredient = ingredient.gsub("/", "")
    ingredient = clean_solr(ingredient)
    # solr_search = Ingredient.find_by_solr(ingredient, :limit => 1)
    # if solr_search.total != 0
    #   solr_search.results.first.id
    # else
    #   #"7629" # PRODUCTION STUB INGREDIENT
    #   "1492" # LOCAL STUB INGREDIENT
    # end
    result = Ingredient.find_or_create_by_name(ingredient)
    result.id
  end
  
  def parse_note(li) # Anything after the last comma
    sections = li.split(", ")
    if sections.length > 1
      note = sections.pop()
      note
    else
      ""
    end
  end
  
  def parse_quantity(li)
    # First we'll strip off everything after the measurement (tbsp, ounch, etc)
    result = strip_html(li).downcase
    measurements = Regexp.new("(#{common_measurements.join("|")})s?")
    matches = result.match(measurements).to_a
    unless matches.empty?
      result = result.split(matches.first)[0]
    else
      result = result.gsub(/[*a-z]/, "")    # remove lower letters
      result = result.gsub(/\([^)]+\)/, "") # remove parans and everything inside them
      result = result.gsub(/\&#[^;]+\;/, "") # remove html codes and everything inside them
      stripper = Regexp.new("(#{remove_me.join("|")})s?")
      result = result.gsub(stripper, "")
      result = result.squeeze!
    end
    result = result.nil? ? "" : result
  end

  def parse_measurement(li)
    measurements = Regexp.new("(#{common_measurements.join("|")})s?")
    string = strip_html(li).downcase
    matches = string.match(measurements).to_a
    matches.empty? ? "" : matches.first
  end

  def strip_html(string)
    string.gsub(/<\/?[^>]*>/, "")
  end
  
  def scrub_line(li)
    ingredient = strip_html(li) # remove HTML
    ingredient = ingredient.gsub(/[*0-9]/, "")    # remove Numbers
    ingredient = ingredient.gsub(/\([^)]+\)/, "")    # remove parans and everything inside them
    stripper = Regexp.new("(#{remove_me.join("|")})s?") # junk
    ingredient = ingredient.downcase.gsub(stripper, "") # remove junk
    stripper = Regexp.new("(#{common_measurements.join("|")})s?") # measurements
    ingredient = ingredient.downcase.gsub(stripper, "")    # remove common measurements
    ingredient
  end
  
  def clean_solr(q)
    clean_query = q.to_s.gsub(/([-!(){}\[\]^~*?:;+\\])/){"\\" + $1}
    clean_query = clean_query.gsub("\"", "\\\"")
    clean_query = clean_query.gsub("\n", " ")
    clean_query = clean_query.gsub(/^\s*(AND|OR|NOT)/, "")
    clean_query = clean_query.gsub(/(AND|OR|NOT)\s*$/, "")
  end
  
  def common_measurements 
    [
    "cup",
    "tbsp", 
    "tablespoon", 
    "tsp", 
    "teaspoon", 
    "pound",
    "ounce",
    "quart", 
    "qt", 
    "liter", 
    "small", 
    "medium",
    "large",
    "head", 
    "whole", 
    "half", 
    "bunch", 
    "stalk",
    "can",
    "dozen",
    "stick",
    "drop",
    "pkg",
    "pinch", 
    "dash", 
    "envelope", 
    "clove", 
    "stalk", 
    "package"]
  end
  
  def notes
    ["minced"]
  end
  
  def remove_me
    ["-", "&", "#", ",", ";", ":"]
  end
  
end