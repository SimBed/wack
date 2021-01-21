class StaticPagesController < ApplicationController
  def home
    # default to demo user logged-in
    log_in(User.find_by(demo: true)) if current_user.nil?
    #select a random workout (dailypick defined in static_pages_helper.rb)
    @workout = Workout.all[dailypick]
    @schedulings = current_user.schedulings.order_by_start_time
  end

  def new
    # see StaticPagesHelper
    @letter = KitchenUtensil.useletter
  end

end
