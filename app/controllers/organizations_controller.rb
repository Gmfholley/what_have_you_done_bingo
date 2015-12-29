class OrganizationsController < ApplicationController
  skip_before_filter :require_login, only: [:new, :create]
  before_action :prevent_duplicate_sessions, only: [:new, :create]
  before_action :set_organization, except: [:new, :create]
  before_action :handle_if_not_authorized, only: [:edit, :update, :destroy]
  before_action :handle_if_not_member, only: [:edit, :update, :show, :destroy]
  
  def new
    @organization = Organization.new
  end
  
  def create
    @organization = Organization.create(organization_only_params)
    @user = User.create(organization_user_only_params)
    @org_user = OrganizationUser.create(organization: @organization, user: @user, role: Role.admin)
    
    if @org_user.blank?
      @user.destroy
      @organization.destroy
      render :new, :notice => "Unable to create a new organization."
    else
      @user = login(@user.email,password_params)
      redirect_to organization_path(@organization.token), :notice => "Thanks for signing up!"
    end
  end
  
  def edit
  end
  
  def update
    if @organization.update(organization_only_params)
      redirect_to organization_path(@organization.token), :notice => "Account updated!"
    else
      render :edit, :notice => "Unable to update your account."
    end
  end
  
  def show
    @user = current_user
    @is_admin = is_admin?
    @admin_id = Role.admin.id
    @user_id = Role.user.id
  end
  
  def destroy
    if @organization.destroy
      redirect_to login_path, :notice => "Your account was deleted."
    else
      redirect_to organization_path(@organization.token), :notice => "Sorry.  Something went wrong.  We are unable to delete the account."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = Organization.find_by(token: params[:id])
    end
    
    def organization_and_user_params
      params.require(:organization).permit(:users_attributes => [:email, :first_name, :last_name, :password,  :password_confirmation])
    end 
    
    def organization_user_only_params
      organization_and_user_params["users_attributes"]["0"]
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_only_params
      params.require(:organization).permit(:name)
    end
        
    def password_params
       params["organization"]["users_attributes"]["0"]["password"]
    end
end
