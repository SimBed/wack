module StaticPagesHelper

    # used in home method of StaticPagesController to select a random Wack
    def dailypick
      require 'date'
      # the seed of the random number generator must change each day but not during the day,
      # so a call to dailypick will return the same output throughout each day
      # and therefore the workout only changes daily
      # to_i only works on objects of Time class, not of Date class
      srand Date.today.to_time.to_i
      return rand(Workout.count)
    end

    class KitchenUtensil
        def self.useletter
          ("A".."Z").to_a.shuffle.first
        end
    end

end
