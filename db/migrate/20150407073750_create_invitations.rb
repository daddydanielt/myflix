class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
        t.integer :inviter_id
        t.string :recipient_name, :recipient_email
        t.text :invitation_message
        t.timestamps
    end
  end
end
