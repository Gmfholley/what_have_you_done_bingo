require 'test_helper'

class TemplatesControllerTest < ActionController::TestCase
  include Sorcery::TestHelpers::Rails::Integration
  include Sorcery::TestHelpers::Rails::Controller
  
  setup do
    @organization = organizations(:factory)
    @non_member = users(:susan)
    @member = users(:david)
    @admin = users(:sally)
    @template = templates(:template_one)
  end
  
  def not_authorized_alert
    "You do not have access to view that page."
  end
  
  def private_notice
    "Sorry.  That is a private template."
  end
  

  test "should get new if an admin" do
    login_user(user = @admin, route = login_path) 
    get :new, organization_id: organizations(:factory)
    assert_response :success
  end
  
  test "should not get new if not an admin" do
    login_user(user = @member, route = login_path) 
    get :new, organization_id: organizations(:factory)
    assert_redirected_to profile_path
    assert_equal flash[:alert], not_authorized_alert
  end
  
  test "should create template if an admin" do
    login_user(user = @admin, route = login_path) 
    assert_difference('Template.count') do
      post :create, organization_id: organizations(:factory), template: { name: @template.name, is_public: @template.is_public, rating: @template.rating }
    end

    assert_redirected_to organization_template_path(organizations(:factory).id, assigns(:template).id)
  end
  
  test "should not create template if not an admin" do
    login_user(user = @member, route = login_path) 
    
    assert_no_difference('Template.count') do
      post :create, organization_id: organizations(:factory), template: { name: @template.name, is_public: @template.is_public, rating: @template.rating }
    end
    
    assert_redirected_to profile_path
    assert_equal flash[:alert], not_authorized_alert
  end

  test "should not show a private template but should show public ones" do
    get :show, organization_id: organizations(:factory), id: @template
    assert_redirected_to :root
    assert_equal flash[:notice], private_notice
    
    @template.update(is_public: true)
    get :show, organization_id: organizations(:factory), id: @template
    assert_response :success  
    
  end
  
  test "should always show private templates to member" do
    login_user(user = @member, route = login_path) 
    get :show, organization_id: organizations(:factory), id: @template
    assert_response :success  
    assert_template :show  
  end

  test "should always show private templates to admin" do
    login_user(user = @admin, route = login_path) 
    get :show, organization_id: organizations(:factory), id: @template
    assert_response :success    
    assert_template :show_admin
  end

  test "should get edit if an admin" do
    login_user(user = @admin, route = login_path)
    get :edit, organization_id: organizations(:factory), id: @template
    assert_response :success
  end

  test "should not get edit template if not an admin" do
    login_user(user = @member, route = login_path) 

    get :edit, organization_id: organizations(:factory), id: @template

    assert_redirected_to profile_path
    assert_equal flash[:alert], not_authorized_alert
  end

  test "should update template if an admin" do
    login_user(user = @admin, route = login_path) 
    
    patch :update, organization_id: organizations(:factory), id: @template, template: { name: @template.name, is_public: @template.is_public, rating: @template.rating }
    assert_redirected_to organization_template_path(@organization.id, @template)
  end
  
  test "should not get update template if not an admin" do
    login_user(user = @member, route = login_path) 

    patch :update, organization_id: organizations(:factory), id: @template, template: { name: @template.name, is_public: @template.is_public, rating: @template.rating }

    assert_redirected_to profile_path
    assert_equal flash[:alert], not_authorized_alert
  end
  

  test "should destroy template if admin" do
    login_user(user = @admin, route = login_path) 
    
    assert_difference('Template.count', -1) do
      delete :destroy, organization_id: organizations(:factory), id: @template
    end

    assert_redirected_to organization_path(organizations(:factory))
  end
  
  test "should not destroy template if not an admin" do
    login_user(user = @member, route = login_path) 
    
    assert_no_difference('Template.count', -1) do
      delete :destroy, organization_id: organizations(:factory), id: @template
    end

    assert_redirected_to profile_path
    assert_equal flash[:alert], not_authorized_alert
    
  end
    
  
  ##################### 
  # Test embedded nested params creation
  ####################
  test "upon creation should create nested params" do
    login_user(user = @admin, route = login_path) 
    
    @new_template = Template.new
    CreateSquares.work(@new_template)
    squares_hash = Hash.new
    @new_template.squares.each_with_index do |square, x|
      square.question = "test"
      squares_hash[x.to_s] = square.attributes
    end
    # assert_equal Hash.new, squares_hash
    assert_difference('Square.count', @new_template.num_squares) do
      post :create, organization_id: organizations(:factory), template: { name: "test", is_public: false, rating: :easy, squares_attributes: squares_hash }
    end
    # assert_equal @new_template.errors.full_messages, ""
  end
  
  
end
