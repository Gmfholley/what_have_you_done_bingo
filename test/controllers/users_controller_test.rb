require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  include Sorcery::TestHelpers::Rails::Integration
  include Sorcery::TestHelpers::Rails::Controller
  
  # setup do
  #   @current_use = users(:susan)
  #   login_user(user = @current_user, route = login_path)
  # end
  
  test "should get new without logging in" do
    get :new
    assert_response :success
  end
  
  test "should create user with correct params and not logging in" do
    assert_difference('User.count') do
      post :create, user: { email: "test@t.com", first_name: "test", last_name: "test", password: "password", password_confirmation: "password" }
    end

    assert_redirected_to profile_path
  end
  
  test "should show user profile page if logged in" do
    @current_user = users(:susan)
    login_user(user = @current_user, route = login_path)
    get :show, id: @current_user.id
    assert_response :success
  end
  
  test "should not show user profile page if not logged in" do
    get :show, id: users(:susan).id
    assert_redirected_to login_path
  end
  

  
  
end
