class AddIndexToVcards < ActiveRecord::Migration
  def change
    add_index :vcards, :type
  end
end
