class RefactorHonorificPrefix < ActiveRecord::Migration
  def change
    drop_table :has_vcards_honorific_prefixes
  end
end
