class StaticPagesController < ApplicationController
  def home
    #select a random workout (dailypick defined in static_pages_helper.rb)
    @workout = Workout.all[dailypick]

    #Pre dailypick I just showed the most recently added workout
    #@workouts = Workout.all.order("created_at desc")
  end

  def new
    # see StaticPagesHelper
    @letter = KitchenUtensil.useletter
  end

end
