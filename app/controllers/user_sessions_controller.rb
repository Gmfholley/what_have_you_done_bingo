class UserSessionsController < ApplicationController
  skip_before_filter :require_login, except: [:destroy]
  
  def new
    @user = User.new
  end

  def create
    if @user = login(params[:email], params[:password])
      redirect_to profile_path, notice: 'All logged in!'
    else
      flash.now[:alert] = "Login didn't work.  Try again."
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to(:login, notice: 'Logged out. Bye for now.')
  end
end
