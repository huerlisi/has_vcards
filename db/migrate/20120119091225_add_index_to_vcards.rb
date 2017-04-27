class AddIndexToVcards < ActiveRecord::Migration[4.2]
  def change
    add_index :vcards, :active
  end
end
