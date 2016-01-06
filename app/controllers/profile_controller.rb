class ProfileController < ApplicationController
  before_action :set_me_as_user
     
  def edit
  end
  
  def update
    if @user.update(user_params)
      redirect_to profile_path, :notice => "Account updated!"
    else
      render :edit, :notice => "Unable to update your account. #{@user.errors}"
    end
  end
  
  def show
    puts "in profile controller"
  end
  
  def destroy
    if @user.destroy
      redirect_to root_path, :notice => "Your account was deleted."
    else
      redirect_to profile_path, :notice => "Sorry.  Something went wrong.  Try again to delete your account."
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :profile_picture)
  end
  
  def set_me_as_user
    @user = current_user
  end
  
end
