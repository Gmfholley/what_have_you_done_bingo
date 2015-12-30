require 'test_helper'

class TemplatesControllerTest < ActionController::TestCase
  setup do
    @template = templates(:one)
  end

  test "should get new" do
    get :new, organization_id: organizations(:factory)
    assert_response :success
  end

  test "should create template" do
    assert_difference('Template.count') do
      post :create, organization_id: organizations(:factory), template: { name: @template.name, organization_id: @template.organization_id, is_public: @template.is_public, rating: @template.rating, size: @template.size }
    end

    assert_redirected_to organization_template_path(organizations(:factory).id, assigns(:template).id)
  end

  test "should show template" do
    get :show, organization_id: organizations(:factory), id: @template
    assert_response :success
  end

  test "should get edit" do
    get :edit, organization_id: organizations(:factory), id: @template
    assert_response :success
  end

  test "should update template" do
    patch :update, organization_id: organizations(:factory), id: @template, template: { name: @template.name, organization_id: @template.organization_id, is_public: @template.is_public, rating: @template.rating, size: @template.size }
    assert_redirected_to organization_template_path(organizations(:factory).id, assigns(:template).id)
  end

  test "should destroy template" do
    assert_difference('Template.count', -1) do
      delete :destroy, organization_id: organizations(:factory), id: @template
    end

    assert_redirected_to templates_path
  end
end
