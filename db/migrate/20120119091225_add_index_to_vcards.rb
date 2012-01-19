class AddIndexToVcards < ActiveRecord::Migration
  def change
    add_index :has_vcards, :type
  end
end
