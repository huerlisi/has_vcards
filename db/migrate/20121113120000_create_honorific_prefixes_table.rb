class CreateHonorificPrefixesTable < ActiveRecord::Migration
  def up
    change_table "honorific_prefixes" do |t|
      t.integer "sex"
      t.string  "name"
      t.integer "position"
    end
  end
end
