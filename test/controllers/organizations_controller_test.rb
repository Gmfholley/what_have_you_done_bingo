require 'test_helper'

class OrganizationsControllerTest < ActionController::TestCase
  include Sorcery::TestHelpers::Rails::Integration
  include Sorcery::TestHelpers::Rails::Controller
  
  setup do
    @organization = organizations(:bank)
    @current_user = users(:susan)
  end
  
  test "should get new without logging in" do
    get :new
    assert_response :success
  end

  test "should create organization, associated user, and relationship" do
    assert_difference('Organization.count') do
      post :create, organization: { name: "test", :users_attributes => {"0" => {email: "test@test.com", first_name: "test", last_name: "test", password: "password", password_confirmation: "password"}}  }
    end

    assert_equal assigns(:organization).users.count, 1, "Did not create a user"
    assert_equal assigns(:organization).organization_users.count, 1, "Did not create an organization_user relationship"
    assert_equal assigns(:organization).organization_users.first.role, Role.admin, "The created organization_user is not an admin"
    
    assert_redirected_to organization_path(assigns(:organization).token), "Did not redirect to the organization path"
  end

  test "should show organization if a member" do
    login_user(user = @current_user, route = login_path) 
    get :show, id: @organization.token
    assert_response :success
  end
  
  test "should not show organization if not a member" do
    login_user(user = users(:david), route = login_path)
    get :show, id: @organization.token
    assert_redirected_to profile_path
  end
  
  test "should get edit if an admin" do
    login_user(user = @current_user, route = login_path) 
    get :edit, id: @organization.token
    assert_response :success
  end
  
  test "should not get edit if not an admin" do
    organization = organizations(:factory)
    login_user(user = users(:david), route = login_path) 
    get :edit, id: organization.token
    assert_redirected_to profile_path
  end

  test "should update organization if an admin" do
    login_user(user = @current_user, route = login_path) 
    patch :update, id: @organization.token, organization: { name: "changedName" }
    assert_equal assigns(:organization).name, "changedName"
    assert_redirected_to organization_path(@organization.token)
  end

  test "should not get update if not an admin" do
    organization = organizations(:factory)
    login_user(user = users(:david), route = login_path) 
    patch :update, id: organization.token, organization: { name: "changedName" }
    assert_redirected_to profile_path
  end
  
  test "should not get update if an admin but not of this organization" do
    @organization = organizations(:factory)
    login_user(user = users(:susan), route = login_path) 
    patch :update, id: @organization.token, organization: { name: "changedName" }
    assert_redirected_to profile_path
  end

  test "should destroy organization if an admin" do
    login_user(user = @current_user, route = login_path) 
    assert_difference('Organization.count', -1) do
      delete :destroy, id: @organization.token
    end

    assert_redirected_to login_path
  end  
  
  test "should not destroy if not an admin" do
    organization = organizations(:factory)
    login_user(user = users(:david), route = login_path) 
    assert_no_difference('Organization.count') do
      delete :destroy, id: organization.token
    end
    assert_redirected_to profile_path
  end
end
