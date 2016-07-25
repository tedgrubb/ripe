class GroceryList < ActiveRecord::Base
  has_many    :grocery_list_memberships, :dependent => :destroy
  has_many    :users, :through => :grocery_list_memberships
  
  has_many    :grocery_list_ingredients, :dependent => :destroy
  has_many    :ingredients, :through => :grocery_list_ingredients
  
  def primary?(user)
    self == user.grocery_list
  end
  
end
