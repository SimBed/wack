class StaticPagesController < ApplicationController
  def home
    #@workouts = Workout.all.order("created_at desc")
    @workout = Workout.all[dailypick]
    #Original code, but cannot assume the ids will be consecutive
    #@workout = Workout.find(dailypick)
  end

private
  #helps select a random Wack
  def dailypick
    require 'date'
    #set the seed..the seed must change each day but not during the day,
    #so that the workout only changes daily
    #to_i only works on Time class not on Date class
    srand Date.today.to_time.to_i
    return rand(Workout.count)
  end

end
