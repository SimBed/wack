class RelUserWorkoutsController < ApplicationController
before_action :logged_in_user
  def create
    workout = Workout.find(params[:workout_id])
    current_user.wkfollow(workout)
    @workout = workout
    respond_to do |format|
       format.html { flash[:success] = "#{workout.name} added to favourites!"
                     redirect_to workout_path(workout) }
       format.js { flash.now[:success] = "#{workout.name} added to favourites!" }
    end
  end

  def destroy
    delworkout = Workout.find(RelUserWorkout.find(params[:id]).workout_id)
    current_user.wkunfollow(delworkout)
    @workout = delworkout
    #unfollow achieves the same as RelUserWorkout.find(params[:id]).destroy
    respond_to do |format|
      format.html { flash[:success] = "#{delworkout.name} removed from favourites!"
                    redirect_to workout_path(delworkout) }
      format.js { flash.now[:success] = "#{delworkout.name} removed from favourites!" }
    end
  end

end
