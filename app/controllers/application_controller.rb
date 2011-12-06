class ApplicationController < ActionController::Base
  include Yogoshu::Locale

  protect_from_forgery

  before_filter :initialize_user
  before_filter :set_locale

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

  def set_locale
    I18n.locale = params[:locale]
    @base_languages = base_languages
    @default_source_language = default_source_language

    if !@base_languages.include?(I18n.locale)
      I18n.locale = @base_languages[0]
    end

    return (true)
  end

  def current_user
    @current_user
  end

end
