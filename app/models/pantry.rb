class Pantry < ActiveRecord::Base
  has_many    :pantry_memberships, :dependent => :destroy
  has_many    :users, :through => :pantry_memberships
  has_many    :pantry_ingredients, :dependent => :destroy
  has_many    :ingredients, :through => :pantry_ingredients
              
  def available_recipes(options = {})
    Recipe.for_ingredients(self.ingredients, options)
  end
  
  def expired_ingredients
    self.pantry_ingredients.expired
  end

end