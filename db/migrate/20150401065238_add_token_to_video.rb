class AddTokenToVideo < ActiveRecord::Migration
  def change
      add_column :videos, :token, :string
      Video.all.each do |v|
        v.token = SecureRandom.urlsafe_base64
        v.save
      end
  end
end
