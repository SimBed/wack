class RelUserWorkoutsController < ApplicationController
before_action :logged_in_user
  def create
  workout = Workout.find(params[:workout_id])
  current_user.wkfollow(workout)
  flash[:success] = "#{workout.name} added to favourites!"
  redirect_to workout_path(workout)
  end

  def destroy
  delworkout = Workout.find(RelUserWorkout.find(params[:id]).workout_id)
  current_user.wkunfollow(delworkout)
  #unfollow achieves the same as
  #RelUserWorkout.find(params[:id]).destroy
  flash[:success] = "#{delworkout.name} removed from favourites!"
  redirect_to workout_path(delworkout)
  end

end
