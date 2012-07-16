class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :location
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
    add_index :events, [:start_date, :end_date]
  end
end
