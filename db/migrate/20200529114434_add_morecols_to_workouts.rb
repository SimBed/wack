class AddMorecolsToWorkouts < ActiveRecord::Migration[5.2]
  def change
    add_column :workouts, :addedby, :string
    add_column :workouts, :brand, :string
    add_column :workouts, :eqpitems, :string
  end
end
