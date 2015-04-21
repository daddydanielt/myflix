class ApplicationController < ActionController::Base
  protect_from_forgery

   # for all controllers and view_templates
  helper_method :logged_in?, :current_user

  def current_user
    begin
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue
      @cuurent_user = nil
    end
  end

  def logged_in?
    !!current_user
  end

  def require_sign_in
    unless logged_in?
      redirect_to signin_path
    end
  end

  #def require_admin
  #  #unless logged_in? && current_user.admin?
  #  if !current_user.admin?
  #    flash[:error] = "Permission denied!!"
  #    redirect_to home_path
  #  end
  #end

end
