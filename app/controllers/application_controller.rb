class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :initialize_user

  # make these available as ActionView helper methods.
  helper_method :logged_in?, :manager?

  protected

  def logged_in?
    current_user.is_a?(User)
  end

  def manager?
    current_user && current_user.role == "manager"
  end

  def login_required
    redirect_to login_path unless logged_in?
  end

  def access_restricted
    redirect_to homepage_path unless manager?
  end

  # setup user info on each page
  def initialize_user
    User.current_user = @current_user = User.find_by_name(session[:user]) if session[:user]
  end

  def current_user
    @current_user
  end

end
