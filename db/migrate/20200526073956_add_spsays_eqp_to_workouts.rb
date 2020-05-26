class AddSpsaysEqpToWorkouts < ActiveRecord::Migration[5.2]
  def change
    add_column :workouts, :spacesays, :text
    add_column :workouts, :equipment, :boolean
  end
end
