class Invite < ActiveRecord::Base

  # after_create send an email off to the invitee
  after_create :send_user_invite_email

  def send_user_invite_email

    # note the deliver_ prefix, this is IMPORTANT
    InviteMailer.deliver_user_invite(self)

  end


end
