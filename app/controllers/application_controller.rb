class ApplicationController < ActionController::Base
  protect_from_forgery

   # for all controllers and view_templates
  helper_method :logged_in?, :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_sign_in
    redirect_to front_path unless logged_in?
  end
end
