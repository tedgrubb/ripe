class CuisinePreference < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :cuisine
  
end
