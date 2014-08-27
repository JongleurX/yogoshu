class SessionsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    if @user = @current_user = User.authenticate(params[:user][:name], params[:user][:password])
      session[:user] = @user.name
      flash[:message] = I18n.t('ui.login_success', :username => @user.name)
    else
      flash.now[:error] = I18n.t('ui.login_failed')
      @user = User.new(params[:user])
      render 'new' and return
    end
    redirect_to homepage_path
  end

  def destroy
    reset_session
    flash[:message] = I18n.t('ui.logout_success')
    redirect_to homepage_path
  end

end