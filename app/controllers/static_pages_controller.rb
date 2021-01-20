class StaticPagesController < ApplicationController
  def home
    #select a random workout (dailypick defined in static_pages_helper.rb)
    @workout = Workout.all[dailypick]
    @schedulings = current_user.schedulings.order_by_start_time
  end

  def new
    # see StaticPagesHelper
    @letter = KitchenUtensil.useletter
  end

  def formtest
    @workoutnew = Workout.new
    @workout1 = Workout.find(1)
  end

end
