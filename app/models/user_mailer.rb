class UserMailer < ActionMailer::Base

  def new_user(user)
    recipients  user.email
    from        "It's Ripe! <info@itsripe.com>"
    subject     "Welcome to It's Ripe!"
    body(:user_name => user.login,
        :pantry_url => user_pantry_url(user),
        :grocery_list_url => user_grocery_list_url(user, user.grocery_list))
  end  

end