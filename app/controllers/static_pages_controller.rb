class StaticPagesController < ApplicationController

  def home
    # default to demo user logged-in
    log_in(User.find_by(demo: true)) if current_user.nil?
    #select a random workout (dailypick defined in static_pages_helper.rb)
    # @workout = Workout.all[dailypick]
    @schedulings = current_user.schedulings.order_by_start_time
    @upcoming_schedulings = @schedulings.has_workout.where("start_time > ?", Time.now().beginning_of_day)
    # @upcoming_schedulings = @schedulings.where("start_time > ? AND workout_id IS NOT NULL", Time.now().beginning_of_day)
    if @upcoming_schedulings.empty?
      @workout = Workout.all[dailypick]
    else
      @workout = Workout.find(@upcoming_schedulings.first.workout_id)
    end
    session[:linked_from] = :welcome
  end

  def new
    # see StaticPagesHelper
    @letter = KitchenUtensil.useletter
  end

end
