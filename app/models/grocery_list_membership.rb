class GroceryListMembership < ActiveRecord::Base
  belongs_to :user
  belongs_to :grocery_list
end
