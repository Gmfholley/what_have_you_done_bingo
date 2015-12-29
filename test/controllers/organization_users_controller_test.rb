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
  
  test "should get new if user is logged in" do
    login_user(user = @admin_user, route = login_path) 
    get :new, id: @organization_without_an_admin.token, user_id: @admin_user.id
    assert_response :success
  end
  
  test "should be redirected to login if user is not logged in" do
    get :new, id: @organization_without_an_admin.token, user_id: @admin_user.id
    
    assert_redirected_to login_path
  end
  
  test "should get redirected back if user is not an admin and attempting to sign up another user" do
    login_user(user = @non_admin_user, route = login_path) 
    get :new, id: @organization_without_an_admin.token, user_id: @admin_user.id
    assert_redirected_to profile_path, "Not authorized but allowed to go"
    assert_equal flash[:alert], "You do not have access to view that page.", "Not the right alert"
  end
  
  test "should get create if user is logged in and is either admin or changing his own account" do 
    login_user(user = @admin_user, route = login_path) 
    assert_difference('OrganizationUser.count', 2) do
      #susan is adding herself to the factory (as a user)
      post :create, id: @organization_without_an_admin.token, user_id: @admin_user.id, organization_user: { organization_id: @organization_without_an_admin.id, user_id: @admin_user.id }
      #susan (who is an admin at the bank), is adding david to the bank
      post :create, id: @organization_with_an_admin.token, user_id: @non_admin_user.id, organization_user: { organization_id: @organization_with_an_admin.id, user_id: @non_admin_user.id }
    end
    assert_redirected_to :back   
    
    
     
  end
  
  test "should not get create if user is not authorized" do 
    login_user(user = @non_admin_user, route = login_path) 
    # david should be able to create something for himself at the bank
    assert_difference('OrganizationUser.count', 1) do
      post :create, id: @organization_with_an_admin.token, user_id: @non_admin_user.id, organization_user: { organization_id: @organization_with_an_admin.id, user_id: @non_admin_user.id }
    end
    # david should not be able to create something for susan at the bank, since he is not 
    assert_no_difference('OrganizationUser.count') do
      post :create, id: @organization_without_an_admin.token, user_id: @admin_user.id, organization_user: { organization_id: @organization_without_an_admin.id, user_id: @admin_user.id }
    end
    
    #but david, as a non-admin, should be redirected with not authorized message
    assert_redirected_to profile_path, "Not authorized but allowed to go"
    assert_equal flash[:alert], "You do not have access to view that page.", "Not the right alert"
  end
  
  test "should get update if user is logged in and authorized" do
    login_user(user = @admin_user, route = login_path) 
    # admin should be able to change their role to an admin
    put :update, id: @organization_with_an_admin.token, user_id: @admin_user.id, organization_user: { organization_id: @organization_with_an_admin.id, user_id: @admin_user.id, role_id: roles(:admin).id }
    assert_equal assigns(:organization_user).role.id, roles(:admin).id
    
    # admin should be able to change their role to a user
    put :update, id: @organization_with_an_admin.token, user_id: @admin_user.id, organization_user: { organization_id: @organization_with_an_admin.id, user_id: @admin_user.id, role_id: roles(:user).id }
    assert_equal assigns(:organization_user).role.id, roles(:user).id

    assert_redirected_to :back    
  end
  
  test "should not update if user is not authorized" do
    login_user(user = @non_admin_user, route = login_path) 
    # non admin should not be able to change their role to an admin
    put :update, id: @organization_without_an_admin.token, user_id: @non_admin_user.id, organization_user: { organization_id: @organization_without_an_admin.id, user_id: @non_admin_user.id, role_id: roles(:admin).id }
    
    
    #but david, as a non-admin, should be redirected with not authorized message
    # assert_redirected_to profile_path, "Not authorized but allowed to go"
    assert_equal flash[:alert], "You do not have access to view that page.", "Not the right alert"  

    # and assert that the role didn't change
    assert_equal @non_admin_user.role(@organization_without_an_admin), roles(:user)
  end
  
  test "should get destroy if user is logged in" do 
    login_user(user = @admin_user, route = login_path) 
    
    # should be able to create and destroy a user
    assert_difference('OrganizationUser.count', 1) do
      post :create, id: @organization_with_an_admin.token, user_id: @non_admin_user.id, organization_user: { organization_id: @organization_with_an_admin.id, user_id: @non_admin_user.id }
    end
    # should be able to destroy new user if an admin
    assert_difference('OrganizationUser.count', -1) do
      delete :destroy, id: @organization_with_an_admin.token, user_id: @non_admin_user.id, organization_user: { organization_id: @organization_with_an_admin.id, user_id: @non_admin_user.id }
    end
        
    # should be able to destroy him/herself
    assert_difference('OrganizationUser.count', -1) do
      delete :destroy, id: @organization_with_an_admin.token, user_id: @admin_user.id, organization_user: { organization_id: @organization_with_an_admin.id, user_id: @admin_user.id }
    end
    assert_redirected_to :back    
  end
  
  test "should not destroy if user is not authorized" do 
    login_user(user = @non_admin_user, route = login_path) 
    
    # should not be able to destroy another party
    assert_no_difference('OrganizationUser.count') do
      delete :destroy, id: @organization_with_an_admin.token, user_id: @admin_user.id, organization_user: { organization_id: @organization_with_an_admin.id, user_id: @admin_user.id }
    end
    assert_redirected_to profile_path, "Not authorized but allowed to go"
    assert_equal flash[:alert], "You do not have access to view that page.", "Not the right alert"  
    
    # should be able to destroy him/herself
    assert_difference('OrganizationUser.count', -1) do
      delete :destroy, id: @organization_without_an_admin.token, user_id: @non_admin_user.id, organization_user: { organization_id: @organization_without_an_admin.id, user_id: @non_admin_user.id }
    end
    assert_redirected_to :back    
  end
  
  
end
