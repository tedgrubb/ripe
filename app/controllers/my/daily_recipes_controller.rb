class My::DailyRecipesController < ApplicationController
  before_filter :login_required, :load_user
  def index
    @user_nav = :home
    begin  
      @daily_recipes = DailyRecommendation.generate_for(@user)
    rescue
      
    else  
    # Other exceptions
    ensure
    # Always will be executed
    end

    @html_title = "My daily recipes"
    respond_to do |format|
      format.js
    end
  end
end