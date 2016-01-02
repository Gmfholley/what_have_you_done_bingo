class OrganizationUsersController < ApplicationController
  before_action :set_organization
  before_action :set_user
  before_action :set_default_role
  
  # GET /organizations/:id/sign_up
  def new
    if is_member?
      redirect_to organization_path(@organization), notice: "You are already a member."
    end
  end
  
  # POST /organizations/:id/sign_up
  def create
    @organization_user = OrganizationUser.new(user: @user, organization: @organization, role: @role)
    if @organization_user.save
      respond_to do |format|
        format.json { render :json => @organization_user, status: :success }
        format.html { redirect_to :back, notice: "Thanks! You joined #{@organization.name}" }
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
        format.html { redirect_to :back, notice: "Thanks!  You dropped #{@organization.name}." }
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
    @organization = Organization.find_by(token: params[:organization_id])
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

end
