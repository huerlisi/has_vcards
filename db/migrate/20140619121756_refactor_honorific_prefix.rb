class RefactorHonorificPrefix < ActiveRecord::Migration[4.2]
  def change
    drop_table :has_vcards_honorific_prefixes
  end
end
