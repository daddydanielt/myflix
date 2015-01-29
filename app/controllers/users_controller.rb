class UsersController < ApplicationController

  def new
    @user =  User.new
  end

  def create
    mass_assignment_attributes = user_params
    @user = User.new(mass_assignment_attributes)
  end

  private
  def user_params
    params.require(:user).permit(:email, :password)
  end

end