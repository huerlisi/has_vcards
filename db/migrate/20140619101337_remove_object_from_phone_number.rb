class RemoveObjectFromPhoneNumber < ActiveRecord::Migration[4.2]
  def change
    remove_column :has_vcards_phone_numbers, :object_id
    remove_column :has_vcards_phone_numbers, :object_type
  end
end
