class CreateSchedulings < ActiveRecord::Migration[5.2]
  def change
    create_table :schedulings do |t|
      t.string :name
      t.datetime :start_time
      t.integer :workout_id
      t.references :user, foreign_key: true

      t.timestamps
    end

  end
end
