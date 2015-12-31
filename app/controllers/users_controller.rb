class UsersController < ApplicationController
  skip_before_filter :require_login, only: [:new, :create]
  before_action :set_user, only: [:show]
  before_action :set_organization, only: [:new, :create]
  before_action :prevent_duplicate_sessions, only: [:create]
  before_action :handle_logged_in_user_to_this_organization, only: [:new]
   
  def new
    if @organization.blank?
      @user = User.new
      @submit_url = users_path
    else
      @user = @organization.users.build
      @submit_url = request.path
    end
  end
  
  def create
    @user = User.create(user_params)
    # for users that sign up through an organization page, also create the association
    # was not able to create embedded params for the user
    if !@organization.blank? && !@user.id.blank?
      assoc = OrganizationUser.create(user: @user, organization: @organization, role: Role.user)
     if assoc.blank?
       @submit_url = request.path
       render :new, :notice => "Unable to create your account."  
       @user.destroy
     else
       @user = login(@user.email, params["user"]["password"])
       redirect_to profile_path, :notice => "Thanks for signing up!"
     end 
    else
      # for users who sign up outside of an organization page, do not create association
      if @user.id.blank?
        @submit_url = request.path
        render :new, :notice => "Unable to create your account."  
      else
        @user = login(@user.email, user_password_params)
        redirect_to profile_path, :notice => "Thanks for signing up!"
      end
    end
  end
  
  def show
  end
  
  private
  
  def user_password_params
    params["user"]["password"]
  end
  
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :profile_picture)
  end
    
  def set_user
    @user = User.find(params[:id])
  end
  
  def set_organization
    @organization = Organization.find_by(token: params[:id])
  end
  
  def handle_logged_in_user_to_this_organization
    if logged_in?
      redirect_to organization_users_path(@organization.id, current_user.id)
    end
  end  
end
