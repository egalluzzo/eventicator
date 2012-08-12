class CreateTalks < ActiveRecord::Migration
  def change
    create_table :talks do |t|
      t.string :title
      t.string :speaker
      t.text :description
      t.string :room
      t.datetime :start_at
      t.datetime :end_at
      t.integer :event_id

      t.timestamps
    end
    add_index :talks, [:event_id, :start_at]
  end
end
