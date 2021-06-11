module StaticPagesHelper
  # used in home method of StaticPagesController to select a random Wack
  def dailypick(days_time = 0)
    require 'date'
    # the seed of the random number generator must change each day but not during the day,
    # so a call to dailypick will return the same output throughout each day
    # and therefore the workout only changes daily
    # to_i only works on objects of Time class, not of Date class
    srand Time.zone.today.to_time.to_i + days_time.day
    rand(Workout.count) - 1
  end

  class KitchenUtensil
    def self.useletter
      ('A'..'Z').to_a.sample
    end
  end
end
