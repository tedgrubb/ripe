class DailyRecommendation < ActiveRecord::Base

  belongs_to  :user
  belongs_to  :recipe

  def self.generate_for(user)
    
    if self.todays_recommendations_for(user).empty?
      
      # Find available recipes and filter by user's cuisine preferences
      # TODO: Add more filters (categories, dietary restrictions, allergies)
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      available_recipe_ids = Recipe.ids_for_ingredients(user.pantry.ingredients)
      user_cuisines = user.cuisines.any? ? user.cuisines : nil
      
      if user_cuisines
        daily_suggestions = 
          Recipe.find(:all, 
                      :joins => "INNER JOIN recipe_cuisines ON recipes.id = recipe_cuisines.recipe_id",
                      :conditions => ['recipe_cuisines.cuisine_id in (?) AND recipes.id in (?)',
                        user_cuisines.map(&:id), available_recipe_ids],
                      :limit => 5)
      end
      
      if !daily_suggestions || daily_suggestions.empty?
        daily_suggestions = 
          Recipe.find(:all, 
                      :joins => "INNER JOIN recipe_cuisines ON recipes.id = recipe_cuisines.recipe_id",
                      :conditions => ['recipes.id in (?)', available_recipe_ids],
                      :limit => 5)
      end
      
      # Add a random recipe based off of user's favorite_food
      # !!! this should probably not happen all the time
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # if user.favorite_food != ""
      #   solr_search = Recipe.find_by_solr(user.favorite_food)
      #   if solr_search.total != 0
      #     favorite_recommendation = solr_search.results[rand(solr_search.total)]
      #     unless favorite_recommendation.nil?
      #       daily_suggestions.push(favorite_recommendation).uniq!
      #     end
      #   end
      # end
      
      # Generate Today's Recommendations
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      daily_suggestions.each do |r|
        DailyRecommendation.create({
          :recipe_id =>   r.id, 
          :user_id =>     user.id
        });
      end

    end
    
    # Return today's recommendations
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    return self.todays_recommendations_for(user)
    
  end
  
  def self.todays_recommendations_for(user)
    return DailyRecommendation.find_all_by_user_id(
      user.id, 
      :conditions => ["created_at > ?", Time.now.beginning_of_day])
  end
  
end
