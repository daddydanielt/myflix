class CreateMyQueue < ActiveRecord::Migration
  def change
    create_table :my_queues do |t|
      t.integer :user_id, :video_id, :list_order
      t.timestamps
    end
  end
end

