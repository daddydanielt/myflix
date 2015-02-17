class CreateReview < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :user_id, :video_id
      t.integer :rating
      t.text :content
      t.timestamps
    end
  end
end
