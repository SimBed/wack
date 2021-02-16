class Scheduling < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :name, presence: true
  validates :start_time, presence: true
  scope :order_by_start_time, -> { order(start_time: :asc) }
  scope :has_workout, -> { where("workout_id IS NOT NULL") }
  # scope :order_by_workout_id_start_time, -> { order(workout_id: :desc, start_time: :asc) }

  def style_icon
    icon_map = { Callisthenics: "Callisthenics.png", Cardio: "Cardio.png",\
                 Dancefitness: "Dancefitness.png", Flexibility: "Flexibility.png",\
                 HIIT: "Cardio.png", Mind: "Mind.png", Mobility: "Mobility.png",\
                 Strength: "Strength.png", Therapeutic: "Therapeutic.png", Yoga: "Yoga.png"\
                }
    icon_map.default = "Callisthenics.png"
    if workout_id.nil?
      icon_map['use_default_icon'.to_sym]
    else
      icon_map[Workout.find(workout_id).style.to_sym]
    end
  end

end
