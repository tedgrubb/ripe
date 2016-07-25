class GroceryListIngredient < ActiveRecord::Base
  belongs_to :ingredient
  belongs_to :grocery_list
end