class OrganizationUsersController < ApplicationController
  # This controller is only used for admins to control their members
  before_action :set_organization
  before_action :require_admin
  before_action :set_user
  before_action :set_role
  before_action :set_organization_user
  
  # GET /organizations/:id/users/:user_id
  def new
    if @organization.users.include?(@user)
      redirect_to organization_path(@organization), notice: "#{@user.first_name} #{@user.last_name} is already a member"
    end
  end
  
  
  # POST /organizations/:id/users/:user_id
  def create
    if @organization_user.save
      respond_to do |format|
        format.json { render :json => @organization_user, status: :success }
        format.html { redirect_to :back, notice: "Thanks! #{@user.first_name} was added to #{@organization.name}" }
      end
    else
      respond_to do |format|
        format.json { render :json => @organization_user.errors.full_messages, status: 422}
        format.html { redirect_to :back, notice: "Oops!  Something happened.  Try again." }        
      end
    
    end
  end
  
  # Patch/Put /organizations/:id/users/:user_id
  def update
    if @organization_user.update(organization_user_params)
      respond_to do |format|
        format.json { render :json => @organization_user, status: :success }
        format.html { redirect_to :back, notice: "Thanks! #{@user.first_name}'s relationship with #{@organization.name} was updated." }
      end
    else
      respond_to do |format|
        format.json { render :json => @organization_user.errors.full_messages, status: 422 }
        format.html { redirect_to :back, notice: "Oops!  Something happened.  Try again."  }
      end
    end
  end
  
  # DELETE /organizations/:id/users/:user_id
  def destroy
    if @organization_user.destroy
      respond_to do |format|
        format.json { render :nothing, status: :success }
        format.html { redirect_to :back, notice: "Thanks!  #{@user.first_name} was removed from #{@organization.name}." }
      end
    else
      respond_to do |format|
        format.json { render :json => @organization_user.errors.full_messages, status: 422 }
        format.html { redirect_to :back, notice: "Oops!  Something happened.  Try again." } 
      end
    end
  end
  
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_organization
    @organization = Organization.find(params[:organization_id])
    if @organization.blank?
      redirect_to :back, notice: "Sorry, that is not a valid request."
    end
  end
  
  # sets the current user
  # Note: if there is no params[:user_id], then the user to change is the current user
  #
  # returns the user to change
  def set_user
    @user = User.find(params[:id])
    if @user.blank?
      redirect_to :back, notice: "Sorry, that is not a valid request."
    end
  end
  
  def set_role      
    @role = Role.find(params[:organization_user][:role_id]) unless params[:organization_user].blank?
    if @role.blank?
      @role = Role.user
    end
  end
  
  def set_organization_user
    @organization_user = OrganizationUser.find_by(user: @user, organization: @organization) || OrganizationUser.new(user: @user, organization: @organization)
    @organization_user.role = @role
  end
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def organization_user_params
    params.require(:organization_user).permit(:user_id, :organization_id, :role_id)
  end
end
