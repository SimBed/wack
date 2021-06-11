class StaticPagesController < ApplicationController
  def home
    log_in(User.find_by(demo: true)) if current_user.nil?
    upcoming_schedulings
    @workout = if @upcoming_schedulings.empty?
                 # select a random workout (dailypick defined in static_pages_helper.rb)
                 Workout.all[dailypick]
               else
                 Workout.find(@upcoming_schedulings.first.workout_id)
               end
    session[:linked_from] = :welcome
  end

  def new
    # see StaticPagesHelper
    @letter = KitchenUtensil.useletter
  end

  private

  def upcoming_schedulings
    @schedulings = current_user.schedulings.order_by_start_time
    @upcoming_schedulings = @schedulings.in_future
  end
end
