class SessionsController < ApplicationController

  def new
  end

  def create
    @current_user = User.authenticate(params[:name], params[:password])
    if @current_user
      session[:user] = @current_user.name
    end
    redirect_to homepage_path
  end

end
