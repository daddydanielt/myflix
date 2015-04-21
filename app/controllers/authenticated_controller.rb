class AuthenticatedController < ApplicationController
  before_action :require_sign_in

  def require_sign_in
    unless logged_in?
      redirect_to signin_path
    end
  end
end