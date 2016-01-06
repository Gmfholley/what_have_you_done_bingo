require 'test_helper'

class CardsControllerTest < ActionController::TestCase
  include Sorcery::TestHelpers::Rails::Integration
  include Sorcery::TestHelpers::Rails::Controller
  
  setup do
    @card = cards(:card_one)
    @non_member = users(:susan)
    @member = users(:david)
    @admin = users(:sally)
    @template = templates(:template_one)
    request.env["HTTP_REFERER"] = root_url
    
  end
  
  def not_authorized_alert
    "You do not have access to view that page."
  end
  
  def private_notice
    "Sorry.  That is a private template."
  end
  
  test "should get logged in user's index of cards" do
    login_user(user = @admin, route = login_path) 

    get :index
    assert_response :success
    assert_not_nil assigns(:cards)
  end

  test "should get new card for template if user is member or if template is public" do
    login_user(user = @admin, route = login_path) 
    get :new, token: @template.token
    assert_response :success
    
    login_user(user = @member, route = login_path)
    get :new, token: @template.token
    assert_response :success
    
  end
  
  test "should also get new card for logged in user if template is public" do 
    login_user(user = @non_member, route = login_path) 
    
    get :new, token: @template.token
    assert_redirected_to :root
    assert_equal flash[:notice], private_notice
    
    @template.update(is_public: true)
    get :new, token: @template.token
    assert_response :success  
  end
  

  test "should create card for member of private template" do
    login_user(user = @admin, route = login_path) 
    assert_difference('Card.count') do
      post :create, token: @template.token, card: { is_public: @card.is_public }
    end
    assert_redirected_to card_path(assigns(:card))
    
    login_user(user = @member, route = login_path) 
    assert_difference('Card.count') do
      post :create, token: @template.token, card: { is_public: @card.is_public }
    end
    assert_redirected_to card_path(assigns(:card))
    
    # should not create for non-member of public template
    login_user(user = @non_member, route = login_path) 
    assert_no_difference('Card.count') do
      post :create, token: @template.token, card: { is_public: @card.is_public }
    end
    assert_redirected_to root_path
    assert_equal flash[:notice], private_notice
  end
  
  test "should create card for logged-in user of public template" do
    @template.update(is_public: true)
    login_user(user = @non_member, route = login_path) 
    assert_difference('Card.count') do
      post :create, token: @template.token, card: { is_public: @card.is_public }
    end
    assert_redirected_to card_path(assigns(:card))
  end


  test "should show card" do
    login_user(user = @admin, route = login_path) 
    
    get :show, id: @card
    assert_response :success
  end

  test "should get edit" do
    login_user(user = @admin, route = login_path) 
    
    get :edit, id: @card
    assert_response :success
  end

  test "should update card" do
    login_user(user = @admin, route = login_path) 
    
    patch :update, id: @card, card: { is_public: @card.is_public, num_bingos: @card.num_bingos, template_id: @card.template_id, user_id: @card.user_id }
    assert_redirected_to card_path(assigns(:card))
  end

  test "owner of card can destroy card" do
    #non_member is owner of card
    login_user(user = @non_member, route = login_path) 

    assert_difference('Card.count', -1) do
      delete :destroy, id: @card
    end

    assert_redirected_to cards_path
  end
end
