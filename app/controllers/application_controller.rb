class ApplicationController < ActionController::Base
  protect_from_forgery

  # make these available as ActionView helper methods.
  helper_method :logged_in?, :admin?

  def logged_in?
    current_user.is_a?(User)
  end

  protected

  def current_user
    @current_user
  end

end
