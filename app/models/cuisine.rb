class Cuisine < ActiveRecord::Base

  def to_param
    "#{id}-#{name.downcase.gsub(/[^[:alnum:]]/,'-')}".gsub(/-{2,}/,'-')
  end

  has_many    :cuisine_preferences, :dependent => :destroy
  has_many    :users, :through => :cuisine_preferences
  
  has_many    :recipe_cuisines, :dependent => :destroy
  has_many    :recipes, :through => :recipe_cuisines
  
end