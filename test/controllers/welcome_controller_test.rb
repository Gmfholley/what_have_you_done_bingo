require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  test "should get index without logging in" do
    get :index
    assert_response :success
  end

end
