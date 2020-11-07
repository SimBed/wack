class Scheduling < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :name, presence: true
  validates :start_time, presence: true
  scope :order_by_start_time, -> { order(start_time: :asc) }
end
