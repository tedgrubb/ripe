class RecipeMailer < ActionMailer::Base

  def share_recipe(params)
    recipients    params[:email]
    from          params[:sender_email]
    subject      "Check out this recipe"
    body(:sender_email => params[:sender_email],
          :message => params[:message],
          :recipe => Recipe.find_by_id(params[:recipe_id]))
  end  

end