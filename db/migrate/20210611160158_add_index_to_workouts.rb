class AddIndexToWorkouts < ActiveRecord::Migration[6.0]
  def change
    add_index :workouts, :name, unique: true
    add_index :workouts, :url, unique: true
  end
end
