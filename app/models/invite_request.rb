class InviteRequest < ActiveRecord::Base

  after_create :send_invite_request_email

  def send_invite_request_email

    InviteRequestMailer.deliver_invite_request(self)

  end

end
