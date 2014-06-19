class RenameVcardObjectToReference < ActiveRecord::Migration
  def change
    rename_column :has_vcards_vcards, :object_id,   :reference_id
    rename_column :has_vcards_vcards, :object_type, :reference_type
  end
end
