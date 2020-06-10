class CreateRelUserWorkouts < ActiveRecord::Migration[5.2]
  def change
    create_table :rel_user_workouts do |t|
      t.integer :user_id
      t.integer :workout_id

      t.timestamps
    end
      add_index :rel_user_workouts, :user_id
      add_index :rel_user_workouts, :workout_id
      add_index :rel_user_workouts, [:user_id, :workout_id], unique: true
  end
end
