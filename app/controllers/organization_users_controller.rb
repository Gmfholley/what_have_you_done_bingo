class OrganizationUsersController < ApplicationController
  before_action :set_organization_user
  before_action :has_authorization
     
  def new
  end
  
  def create
    if @organization_user.save
      respond_to do |format|
        format.json { render :json => @organization_user, status: :success }
        format.html { redirect_to :back, notice: "Thanks! #{@change_user.first_name} was added to #{@organization.name}" }
      end
    else
      respond_to do |format|
        format.json { render :json => @organization_user.errors.full_messages, status: 422}
        format.html { redirect_to :back, notice: "Oops!  Something happened.  Try again." }        
      end
    
    end
  end
  
  def update
    if @organization_user.update(organization_user_params)
      respond_to do |format|
        format.json { render :json => @organization_user, status: :success }
        format.html { redirect_to :back, notice: "Thanks! #{@change_user.first_name}'s relationship with #{@organization.name} was updated." }
      end
    else
      respond_to do |format|
        format.json { render :json => @organization_user.errors.full_messages, status: 422 }
        format.html { redirect_to :back, notice: "Oops!  Something happened.  Try again."  }
      end
    end
  end
  
  def destroy
    if @organization_user.destroy
      respond_to do |format|
        format.json { render :nothing, status: :success }
        format.html { redirect_to :back, notice: "Thanks!  #{@change_user.first_name} was removed from #{@organization.name}." }
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
    @organization = Organization.find_by(token: params[:id])
    if @organization.blank?
      redirect_to :back, notice: "Sorry, that is not a valid request."
    end
  end
  
  # sets the current user
  # Note: if there is no params[:user_id], then the user to change is the current user
  #
  # returns the user to change
  def set_change_user
    if params[:user_id].blank?
      @change_user = current_user
    else
      @change_user = User.find(params[:user_id])
    end
    if @change_user.blank?
      redirect_to :back, notice: "Sorry, that is not a valid request."
    end
  end
  
  def set_new_role
    if params[:organization_user].blank? || params[:organization_user][:role_id].blank?
      @role = Role.user
    else
      @role = Role.find(params[:organization_user][:role_id])
    end
    if @role.blank?
      @role = Role.user
    end
  end
  
  def set_organization_user
    set_change_user
    set_organization
    set_new_role
    @organization_user = OrganizationUser.find_by(user: @change_user, organization: @organization) || OrganizationUser.new(user: @change_user, organization: @organization)
    @organization_user.role = @role
  end
  
  # is the user to be changed the same as the logged in user?
  #
  # returns boolean
  def change_user_is_current_user?
    @change_user == current_user
  end
  
  # if the post/put/patch params are attempting to update to an admin
  # if they don't exist, the attempt is not being made
  #
  #
  # returns boolean
  def attempting_to_make_an_admin?
    if params[:organization_user]
      params[:organization_user][:role_id].to_i == Role.admin.id
    else
      false
    end
  end
  
  # if you are an admin
  # OR
  # if you are the current user && you are not attempting to make yourself an admin
  # ==> authorized
  #
  # returns nothing
  def has_authorization
    if !(is_admin? || (change_user_is_current_user? && !attempting_to_make_an_admin?))    
      not_authorized
    end
  end
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def organization_user_params
    params.require(:organization_user).permit(:user_id, :organization_id, :role_id)
  end
end
