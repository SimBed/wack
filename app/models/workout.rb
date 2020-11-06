class Workout < ApplicationRecord
  has_many :attempts, dependent: :destroy
  has_many :microposts, dependent: :destroy
  has_many :rel_user_workouts, dependent: :destroy
  has_many :users, through: :rel_user_workouts
  has_many :schedulings, dependent: :destroy
  #default scope clashed with postgres when using Workout.distinct..  defaultscope warned against generally in stackoverflow. Scopes work nicely.
  #default_scope -> { order(created_at: :desc) }
  scope :order_by_date_created_desc, -> { order(created_at: :desc) }
  scope :order_by_date_created_asc, -> { order(created_at: :asc) }
  scope :order_by_style, -> { order(style: :asc) }
  scope :order_by_intensity, -> { order(intensity: :asc) }
  scope :order_by_length_desc, -> { order(length: :desc) }
  scope :order_by_length_asc, -> { order(length: :asc) }
  scope :order_by_focus, -> { order(bodyfocus: :asc) }
  scope :order_by_brand, -> { order(brand: :asc) }
  scope :order_by_random, -> { order("RANDOM()") }

  validates :name,  presence: true, length: { maximum: 26 },
                    uniqueness: { case_sensitive: false }
  #VALID_URL_REGEX = /
  validates :url, presence: true, length: { maximum: 255 },
                    #format: { with: VALID_URL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :brand, presence: true, length: { maximum: 24 }
end
