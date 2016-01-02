class OrganizationSignupController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  before_action :set_organization
  before_action :set_user, only: [:destroy]
  before_action :set_default_role
  
  # GET /organizations/:id/sign_up
  def new
    @organization_user = OrganizationUser.new
    @user = User.new
    if is_member?
      redirect_to organization_path(@organization), notice: "You are already a member."
    end
  end
  
  # POST /organizations/:id/sign_up
  def create
    if logged_in?
      @user = current_user
    else
      @user = User.new(user_params)
      if !@user.save
        respond_to do |format|
          format.json { render :json => @user.errors.full_messages, status: 422}
          format.html { render :new, notice: "Sorry, there were some problems creating your account."}
        end
        return
      end
    end
    @organization_user = OrganizationUser.new(user: @user, organization: @organization, role: @role)
    if @organization_user.save
      respond_to do |format|
        format.json { render :json => @organization_user, status: :success }
        format.html { redirect_to organization_path(@organization), notice: "Thanks! You joined #{@organization.name}" }
      end
    else
      respond_to do |format|
        format.json { render :json => @organization_user.errors.full_messages, status: 422}
        format.html { redirect_to :back, notice: "Oops!  Something happened.  Try again." }        
      end
    end
  end
    
  # DELETE /organizations/:id/remove
  def destroy
    @organization_user = OrganizationUser.find_by(user: @user, organization: @organization)
    if @organization_user.destroy
      respond_to do |format|
        format.json { render :nothing, status: :success }
        format.html { redirect_to profile_path, notice: "Thanks!  You dropped #{@organization.name}." }
      end
    else
      respond_to do |format|
        format.json { render :json => @organization_user.errors.full_messages, status: 422 }
        format.html { redirect_to :back, notice: "Oops!  Something happened.  Try again." } 
      end
    end
  end
  
  private

  def set_organization
    @organization = Organization.find_by(token: params[:id])
    if @organization.blank?
      redirect_to :back, notice: "Sorry, that is not a valid request."
    end
  end
  
  def set_user
    @user = current_user
  end
  
  def set_default_role    
    @role = Role.user
  end
  
  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password,  :password_confirmation)
  end 

end
