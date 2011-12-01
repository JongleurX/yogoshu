class SessionsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    if @user = User.authenticate(params[:user][:name], params[:user][:password])
      session[:user] = @user.name
      flash[:message] = "You've successfully logged in. Welcome back #{@user.name}!"
    else
      flash.now[:error] = "Username or password incorrect. Please try again."
      @user = User.new(params[:user])
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
