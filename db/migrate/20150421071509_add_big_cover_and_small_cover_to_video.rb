class AddBigCoverAndSmallCoverToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :big_cover, :string
    add_column :videos, :small_cover, :string
    remove_column :videos, :small_cover_url
    remove_column :videos, :big_cover_url
  end
end
