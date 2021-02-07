class Scheduling < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :name, presence: true
  validates :start_time, presence: true
  scope :order_by_start_time, -> { order(start_time: :asc) }
  scope :has_workout, -> { where("workout_id IS NOT NULL") }
  # scope :order_by_workout_id_start_time, -> { order(workout_id: :desc, start_time: :asc) }
end
