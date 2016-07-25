class InviteRequestMailer < ActionMailer::Base

  def invite_request(invite_request)
    recipients  "invite_requests@itsripe.com"
    from        invite_request.email
    subject     "Invite Request"
    body :request_email => invite_request.email
  end

end