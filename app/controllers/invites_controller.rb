class InvitesController < ApplicationController
  layout 'home'
  def index
    if (current_user && current_user.is_admin)
      @invites = Invite.find(:all)
    else
      redirect_to "/"
    end
  end
  
  def new
    @invite = Invite.new
  end
  
  def create
    @invite = Invite.new(params[:invite])
    
    respond_to do |format|
      if @invite.save!
        current_user.invites = current_user.invites-1
        current_user.save
        flash[:notice] = 'Invite was successfully sent.'
        format.html { redirect_to('/') }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
end
