require 'test_helper'

class DefsetsControllerTest < ActionController::TestCase
  setup do
    @defset = defsets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:defsets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create defset" do
    assert_difference('Defset.count') do
      post :create, defset: { name: @defset.name, value: @defset.value }
    end

    assert_redirected_to defset_path(assigns(:defset))
  end

  test "should show defset" do
    get :show, id: @defset
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @defset
    assert_response :success
  end

  test "should update defset" do
    patch :update, id: @defset, defset: { name: @defset.name, value: @defset.value }
    assert_redirected_to defset_path(assigns(:defset))
  end

  test "should destroy defset" do
    assert_difference('Defset.count', -1) do
      delete :destroy, id: @defset
    end

    assert_redirected_to defsets_path
  end
end
