class RecipeCuisine < ActiveRecord::Base
  belongs_to :cuisine
  belongs_to :recipe
end