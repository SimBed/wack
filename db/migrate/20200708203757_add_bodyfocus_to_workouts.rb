class AddBodyfocusToWorkouts < ActiveRecord::Migration[5.2]
  def change
    add_column :workouts, :bodyfocus, :string
  end
end
