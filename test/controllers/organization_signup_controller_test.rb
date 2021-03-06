require 'test_helper'

class OrganizationSignupControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  include Sorcery::TestHelpers::Rails::Integration
  include Sorcery::TestHelpers::Rails::Controller
  
  setup do
    @organization = organizations(:factory)
    @non_member = users(:susan)
    @member = users(:david)
    request.env["HTTP_REFERER"] = root_url
  end
    
  # GET /organizations/:id/sign_up
    
  test 'user should be able to get new membership page if not a member' do 
    login_user(user = @non_member, route = login_path) 
    get :new, id: @organization.token
    assert_response :success
  end
  
  test 'if already a user should be redirected back to organization page' do
    login_user(user = @member, route = login_path) 
    get :new, id: @organization.token
    assert_redirected_to organization_path(@organization)
    assert_equal flash[:notice], "You are already a member."
  end
  
  test 'if not logged in, should allow user to create an account page' do
    get :new, id: @organization.token
    assert_response :success    
  end
  
  test 'logged in user should be able to become a member' do 
    login_user(user = @non_member, route = login_path)
    
    assert_difference('OrganizationUser.count', 1) do 
      post :create, id: @organization.token
    end
    assert_redirected_to organization_path(@organization)
  end
  
  test 'if not logged in, should be able to create self and become a member' do
    assert_difference('User.count', 1) do
      assert_difference('OrganizationUser.count', 1) do
        post :create, id: @organization.token, user: { email: "test@t.com", first_name: "test", last_name: "test", password: "password", password_confirmation: "password" }
      end
    end
    assert_redirected_to organization_path(@organization)
  end
  
  test 'should be able to destroy their relationship' do
    login_user(user = @member, route = login_path) 
    assert_difference('OrganizationUser.count', -1) do 
      delete :destroy, id: @organization.token
    end
    assert_redirected_to profile_path
  end  
  
end
