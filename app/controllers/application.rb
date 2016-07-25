# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  include AuthenticatedSystem
  include ActsAsTinyURL
  
  before_filter :adjust_format_for_iphone
  #before_filter :login_required
  filter_parameter_logging :password
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # protect_from_forgery # :secret => '31cddb2e42fc06827f2bdb3f9e2dc8d8'

private

  def adjust_format_for_iphone
    request.format = :iphone if iphone_request?
  end
  
  def iphone_request?
    return (request.subdomains.first == "iphone" || params[:format] == "iphone")
  end
  
  def load_user
    @user = current_user
  end
  
end
