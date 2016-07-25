require 'test_helper'

class Users::GroceryListsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:users_grocery_lists)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_grocery_list
    assert_difference('Users::GroceryList.count') do
      post :create, :grocery_list => { }
    end

    assert_redirected_to grocery_list_path(assigns(:grocery_list))
  end

  def test_should_show_grocery_list
    get :show, :id => users_grocery_lists(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => users_grocery_lists(:one).id
    assert_response :success
  end

  def test_should_update_grocery_list
    put :update, :id => users_grocery_lists(:one).id, :grocery_list => { }
    assert_redirected_to grocery_list_path(assigns(:grocery_list))
  end

  def test_should_destroy_grocery_list
    assert_difference('Users::GroceryList.count', -1) do
      delete :destroy, :id => users_grocery_lists(:one).id
    end

    assert_redirected_to users_grocery_lists_path
  end
end
