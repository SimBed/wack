class Problem < ApplicationRecord
  has_many :relationship_ps, dependent: :destroy
  has_many :users, through: :relationship_ps
end
