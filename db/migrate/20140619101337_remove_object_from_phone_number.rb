class RemoveObjectFromPhoneNumber < ActiveRecord::Migration
  def change
    remove_column :has_vcards_phone_numbers, :object_id
    remove_column :has_vcards_phone_numbers, :object_type
  end
end
