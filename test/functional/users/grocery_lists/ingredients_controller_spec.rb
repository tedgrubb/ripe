require File.dirname(__FILE__) + '/../../../test_helper'

class Users::GroceryLists::IngredientsControllerTest < ActionController::TestCase
  
  def test_foo
    get :index
    assert_response :success
  end
  
end