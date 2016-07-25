class KitchenToolsController < ApplicationController
  
  before_filter :load_kitchen_tool, :only => [:show, :edit, :update]
  before_filter :set_navigation

  def index
    @html_title = "Kitchen Tools"
    @kitchen_tools = KitchenTool.paginate :page => params[:page], :order => :name, :per_page => 20
  end
  
  def show
    @html_title = @kitchen_tool.name
  end
  
  def edit
    @html_title = "Edit #{@kitchen_tool.name}"
  end
  
  def update
    respond_to do |format|
      @kitchen_tool.attributes = params[:kitchen_tool]
      if @kitchen_tool.save
        flash[:notice] = 'Kitchen tools successfully updated.'
        format.html { redirect_to(@kitchen_tool) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
public

  def set_navigation
    @user_nav = :tools    
  end

  def load_kitchen_tool
    @kitchen_tool = KitchenTool.find(params[:id])    
  end
  
end