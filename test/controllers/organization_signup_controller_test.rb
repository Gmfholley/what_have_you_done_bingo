require 'test_helper'

class OrganizationUsersControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  include Sorcery::TestHelpers::Rails::Integration
  include Sorcery::TestHelpers::Rails::Controller
  
  setup do
    @organization_without_an_admin = organizations(:factory)
    @organization_with_an_admin = organizations(:bank)
    @admin_user = users(:susan)
    @non_admin_user = users(:david)
    request.env["HTTP_REFERER"] = root_url
  end
    
  test "should be redirected to login for any path if user is not admin" do
    login_user(user = @non_admin_user, route = login_path) 
    get :new, organization_id: @organization_without_an_admin, id: @admin_user.id
    assert_redirected_to profile_path
    assert_equal flash[:alert], "You do not have access to view that page.", "Not the right alert"
    
    post :create, organization_id: @organization_without_an_admin, id: @admin_user.id, organization_user: { organization_id: @organization_without_an_admin.id, id: @admin_user.id }
    assert_redirected_to profile_path
    assert_equal flash[:alert], "You do not have access to view that page.", "Not the right alert"
    
    put :update, organization_id: @organization_with_an_admin, id: @admin_user.id, organization_user: { organization_id: @organization_with_an_admin.id, id: @admin_user.id, role_id: roles(:user).id }
    assert_redirected_to profile_path
    assert_equal flash[:alert], "You do not have access to view that page.", "Not the right alert"
    
    delete :destroy, organization_id: @organization_without_an_admin, id: @non_admin_user.id, organization_user: { organization_id: @organization_without_an_admin.id, user_id: @non_admin_user.id }
    assert_redirected_to profile_path
    assert_equal flash[:alert], "You do not have access to view that page.", "Not the right alert"
    
  end
  
  test "should get create if user is admin" do 
    login_user(user = @admin_user, route = login_path) 
    assert_difference('OrganizationUser.count', 1) do
      #susan (who is an admin at the bank), is adding david to the bank
      post :create, organization_id: @organization_with_an_admin, id: @non_admin_user.id, organization_user: { organization_id: @organization_with_an_admin.id, user_id: @non_admin_user.id, role_id: roles(:user).id }
    end
    assert_redirected_to :back        
  end
  
  test "should get update if user is admin" do
    login_user(user = @admin_user, route = login_path) 
    # admin should be able to change their role to a user
    put :update, organization_id: @organization_with_an_admin, id: @admin_user.id, organization_user: { organization_id: @organization_with_an_admin.id, id: @admin_user.id, role_id: roles(:user).id }
    assert_equal assigns(:organization_user).role.id, roles(:user).id

    assert_redirected_to :back    
  end
    
  test "should get destroy if user is admin" do 
    login_user(user = @admin_user, route = login_path) 
    
    # should be able to create and destroy a user
    assert_difference('OrganizationUser.count', 1) do
      post :create, organization_id: @organization_with_an_admin, id: @non_admin_user.id, organization_user: { organization_id: @organization_with_an_admin.id, user_id: @non_admin_user.id, role_id: roles(:user).id }
    end
    # should be able to destroy new user if an admin
    assert_difference('OrganizationUser.count', -1) do
      delete :destroy, organization_id: @organization_with_an_admin, id: @non_admin_user.id, organization_user: { organization_id: @organization_with_an_admin.id, user_id: @non_admin_user.id, role_id: roles(:user).id }
    end
        
    # should be able to destroy him/herself
    assert_difference('OrganizationUser.count', -1) do
      delete :destroy, organization_id: @organization_with_an_admin, id: @admin_user.id, organization_user: { organization_id: @organization_with_an_admin.id, user_id: @admin_user.id, role_id: roles(:user).id }
    end
    assert_redirected_to :back    
  end
    
  
end
