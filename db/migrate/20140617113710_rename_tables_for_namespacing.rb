class RenameTablesForNamespacing < ActiveRecord::Migration[4.2]
  def change
    rename_table :addresses, :has_vcards_addresses
    rename_table :honorific_prefixes, :has_vcards_honorific_prefixes
    rename_table :phone_numbers, :has_vcards_phone_numbers
    rename_table :vcards, :has_vcards_vcards
  end
end
