class SessionsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @current_user = User.authenticate(params[:user][:name], params[:user][:password])
    if @current_user
      session[:user] = @current_user.name
    else
      render 'new' and return
    end
    redirect_to homepage_path
  end

  def destroy
    reset_session
    redirect_to homepage_path
  end

end
