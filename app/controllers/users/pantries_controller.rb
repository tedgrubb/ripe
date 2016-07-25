class Users::PantriesController < ApplicationController
  before_filter :load_user
  layout 'users'
  
  def show 
    @user_nav = :you
    @sub_nav_item = :pantry
    @categories = Category.find(:all)
    @html_title = "#{@user.possessive_name} Pantry"
    @pantry = @user.pantry
    respond_to do |format|
      format.html { 
        @ingredients = @pantry.pantry_ingredients.paginate :page => params[:page], :order => "created_at DESC",  :limit => 10
        render :action => "show" 
      }
      format.iphone { 
        @ingredients = @pantry.ingredients.find(:all)
        render :action => "show", :layout => "iphone" 
      }
    end
  end
  
  private
  
  def load_user
    @user = User.find(params[:user_id])
  end
  
end
