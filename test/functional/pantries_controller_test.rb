require File.dirname(__FILE__) + '/../test_helper'

class PantriesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:pantries)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_pantry
    assert_difference('Pantry.count') do
      post :create, :pantry => { }
    end

    assert_redirected_to pantry_path(assigns(:pantry))
  end

  def test_should_show_pantry
    get :show, :id => pantries(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => pantries(:one).id
    assert_response :success
  end

  def test_should_update_pantry
    put :update, :id => pantries(:one).id, :pantry => { }
    assert_redirected_to pantry_path(assigns(:pantry))
  end

  def test_should_destroy_pantry
    assert_difference('Pantry.count', -1) do
      delete :destroy, :id => pantries(:one).id
    end

    assert_redirected_to pantries_path
  end
end
