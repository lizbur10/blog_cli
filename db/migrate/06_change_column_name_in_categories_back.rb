class ChangeColumnNameInCategoriesBack < ActiveRecord::Migration[4.2]
    rename_column(:categories, :label, :name)
end