class UsersController < ApplicationController
  layout 'users', :only => [:show, :edit, :index]
  before_filter :login_required, :only => :edit

  def index
    @users = User.paginate(:page => params[:page], :order => "created_at DESC")
  end

  def show
    load_user
    if @user == current_user
      redirect_to user_pantry_path(@user)
    else
      redirect_to user_recipes_path(@user)
    end
  end
  
  def new
    @user = User.new
    render :action => 'new', :layout => "session"
  end
  
  def edit
    load_user
    if current_user && !current_user.can_edit_user(@user)
      flash[:notice] = "You don't have permission to edit that account"
      redirect_to "/"
    end
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      redirect_to(user_setup_path(@user))
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new', :layout => "session"
    end
  end
  
  def update
    load_user
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'user was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
  def load_user
    @user = User.find(params[:id])
  end
end
