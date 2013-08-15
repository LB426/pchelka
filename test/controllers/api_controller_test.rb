require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  test "should get queue" do
    get :queue
    assert_response :success
  end

end
