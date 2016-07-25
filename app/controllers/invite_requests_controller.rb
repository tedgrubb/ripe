class InviteRequestsController < ApplicationController

  def index
    if (current_user && current_user.is_admin)
      @invite_requests = InviteRequest.all
    else
      redirect_to "/"
    end
  end

  def new
    @html_title = "Request an invite to our beta"
    @invite_request = InviteRequest.new
  end
  
  def create
    @invite_request = InviteRequest.new(params[:invite_request])
    if @invite_request.save!
      flash[:notice] = "Request has been received! We'll let you know when we're ready for you. Thanks!"
      redirect_to "/"
    else
      flash[:notice] = "Hmm... Something went wrong. Please try again later."
      redirect_to "/"
    end
  end
  
end