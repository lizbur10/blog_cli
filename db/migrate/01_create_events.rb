class CreateEvents < ActiveRecord::Migration[4.2]
  def change
    create_table :events do |t|
      t.string :name
      t.string :dates
      t.string :deal_url
      t.string :website_url
      t.string :details_url
      t.string :description
      t.integer :category_id
      t.integer :venue_id
      t.integer :sponsor_id
    end
  end
end
