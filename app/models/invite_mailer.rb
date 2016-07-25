class InviteMailer < ActionMailer::Base

  def user_invite(invite)
    recipients  invite.email
    from        "It's Ripe! <invites@itsripe.com>"
    headers     "Reply-to" => "#{User.find_by_id(invite.sender).email}"
    subject     "Help beta test a fun new recipe site"
    body(:sender_name => User.find_by_id(invite.sender).login,
          :signup_url => "http://itsripe.com/users/new?invite_id=#{invite.id}")
  end  

end