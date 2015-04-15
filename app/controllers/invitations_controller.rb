class InvitationsController < ApplicationController
  before_action :require_sign_in

  def new
    @invitation =  Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params)
    if @invitation.save
      #-->
      #AppMailer.send_invitation_email(@invitation).deliver
      #-->
      # using Sidekiq background job
      AppMailer.delay.send_invitation_email(@invitation)
      #-->
      flash[:success] = "Successfully sends your invitaion email to your friend."
      redirect_to new_invitation_path
    else
      flash[:notice] = "Ooops, we can't send the invitaion email right now."
      render :new
    end
  end

  private
  def invitation_params
    params.require(:invitation).permit(:recipient_name, :recipient_email, :invitation_message).merge!(inviter_id: current_user.id)
  end
end