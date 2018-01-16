class ChangeEventDatesToString < ActiveRecord::Migration[4.2]
    change_column :events, :dates, :string
end