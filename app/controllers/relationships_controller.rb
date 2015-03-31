class RelationshipsController < ApplicationController

  before_action :require_sign_in

  def create
    following_user = User.find(params[:following_user_id])
    current_user.following_relationships << Relationship.new(following: following_user, follower: current_user)
    redirect_to people_path
  end

  def following

  end

  def destroy
    relationship = Relationship.find_by(id: params[:id] )        
    if relationship && relationship.follower == current_user              
      relationship.delete
      flash[:notice] = "you've delete the following user, '#{relationship.follower.full_name}'."
    else
      flash[:error] = " You can't delete the users you aren't following."
    end
    redirect_to people_path
  end

end