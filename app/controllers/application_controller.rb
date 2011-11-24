class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :initialize_user

  # make these available as ActionView helper methods.
  helper_method :logged_in?, :admin?

  protected

  def logged_in?
    current_user.is_a?(User)
  end

  # setup user info on each page
  def initialize_user
    User.current_user = @current_user = User.find_by_name(session[:user]) if session[:user]
  end

  def current_user
    @current_user
  end

end
