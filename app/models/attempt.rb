class Attempt < ApplicationRecord
  belongs_to :user
  belongs_to :workout
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :workout_id, presence: true
  validates :doa, presence: true
  validates :summary, length: { maximum: 140 }
end
