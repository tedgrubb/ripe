# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  skip_before_filter :login_required
  before_filter :dont_set_trackback
  layout 'session'

  def new
    @html_title = "Log in to your account"
    respond_to do |format|
      format.html
      format.iphone { render :action => "new", :layout => "iphone" }
    end
  end

  def create
    logout_keeping_session!
    user = User.authenticate(params[:email], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      redirect_back_or("/")
    else
      note_failed_signin
      @email       = params[:email]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    redirect_back_or("/")
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Email and Password don't match."
    logger.warn "Failed login for '#{params[:email]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
  def dont_set_trackback
    @no_trackback = true
  end
end
