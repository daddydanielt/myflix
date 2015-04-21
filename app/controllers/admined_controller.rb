class AdminedController < AuthenticatedController
  before_action :require_admin
  def require_admin
    # Rails will automatically add the method of 'admin?'
    if !current_user.admin?
      flash[:error] = "Permission denied!!"
      redirect_to home_path
    end
  end
end