class SessionsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @current_user = User.authenticate(params[:user][:name], params[:user][:password])
    if @current_user
      session[:user] = @current_user.name
      flash[:message] = "You've successfully logged in. Welcome back #{@current_user.name}!"
    else
      flash.now[:error] = "Username or password incorrect. Please try again."
      render 'new' and return
    end
    redirect_to homepage_path
  end

  def destroy
    reset_session
    flash[:message] = "You've successfully logged out."
    redirect_to homepage_path
  end

end
