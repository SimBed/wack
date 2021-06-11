class RelUserWorkoutsController < ApplicationController
  before_action :logged_in_user
  def create
    workout = Workout.find(params[:workout_id])
    current_user.wkfollow(workout)
    @workout = workout
    ajax_respond_add
  end

  def destroy
    delworkout = Workout.find(RelUserWorkout.find(params[:id]).workout_id)
    current_user.wkunfollow(delworkout)
    @workout = delworkout
    # unfollow achieves the same as RelUserWorkout.find(params[:id]).destroy
    ajax_respond_remove
  end

  private

  def ajax_respond_add
    respond_to do |format|
      format.html do
        flash[:success] = "#{workout.name} added to favourites!"
        redirect_to workout_path(workout)
      end
      format.js { flash.now[:success] = "#{workout.name} added to favourites!" }
    end
  end

  def ajax_respond_remove
    respond_to do |format|
      format.html do
        flash[:success] = "#{delworkout.name} removed from favourites!"
        redirect_to workout_path(delworkout)
      end
      format.js { flash.now[:success] = "#{delworkout.name} removed from favourites!" }
    end
  end
end
