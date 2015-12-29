class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :require_login
  
  
  private
  # redirects user to login path
  #
  # returns nothing
  def not_authenticated
    redirect_to login_path, alert: "You are not logged in. Please log in."
  end
  
  # returns to profile path
  #
  # returns nothing
  def not_authorized
    redirect_to profile_path, alert: "You do not have access to view that page."
  end
  
  # if not an admin, redirects to not_admin path
  #
  # returns nothing
  def handle_if_not_authorized
    if !is_admin?
      not_authorized
    end
  end
  
  # checks if current user is an admin
  #
  # returns boolean
  def is_admin?
    current_user.role(@organization) == Role.admin
  end
    
  # checks if be current user belongs to @organization and if not redirects them
  #
  # returns an boolean
  def belongs_to_organization?
    @organization.users.include?(current_user)
  end
  
  # if not an admin, redirects to not_admin path
  #
  # returns nothing
  def handle_if_not_member
    if !belongs_to_organization?
      not_authorized
    end
  end
    
  def prevent_duplicate_sessions
    if current_user
      redirect_to profile_path, :notice => "You are already logged in.  To create a new account, log out first."
    end
  end  
end
