class CreateEvents < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :name
      t.datetime :dates
      t.string :deal_url
      t.string :website_url
      t.integer :category_id
      t.integer :venue_id
      t.integer :sponsor_id
    end
  end
end
