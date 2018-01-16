class RenameColumnInCategories < ActiveRecord::Migration[4.2]
    rename_column(:categories, :name, :label)
end