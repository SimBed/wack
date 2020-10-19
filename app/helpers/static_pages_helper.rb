module StaticPagesHelper

    #helps select a random Wack
    def dailypick
      require 'date'
      #set the seed..the seed must change each day but not during the day,
      #so that the workout only changes daily
      #to_i only works on Time class not on Date class
      srand Date.today.to_time.to_i
      return rand(Workout.count)
    end

    class KitchenUtensil
        def self.useletter
          ("A".."Z").to_a.shuffle.first
        end
    end

end
