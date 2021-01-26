class AddShortNameToWorkouts < ActiveRecord::Migration[5.2]
  def change
    add_column :workouts, :short_name, :string
  end
end
