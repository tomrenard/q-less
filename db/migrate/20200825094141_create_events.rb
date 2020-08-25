class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :title
      t.string :description
      t.string :category
      t.datetime :start_time
      t.datetime :end_time
      t.string :address
      t.integer :price
      t.text :line_up
      t.references :user, null: false, foreign_key: true
      t.string :location
      t.integer :average_queue

      t.timestamps
    end
  end
end
