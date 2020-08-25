class CreateQueueEstimations < ActiveRecord::Migration[6.0]
  def change
    create_table :queue_estimations do |t|
      t.references :event, null: false, foreign_key: true
      t.integer :waiting_time
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
