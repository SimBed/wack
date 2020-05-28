class Workout < ApplicationRecord
  has_many :microposts, dependent: :destroy
  #before_save   :downcase_url
  validates :name,  presence: true, length: { maximum: 50 },
                    uniqueness: { case_sensitive: false }
  #VALID_URL_REGEX = /
  validates :url, presence: true, length: { maximum: 255 }
                    #format: { with: VALID_URL_REGEX },
                    #uniqueness: { case_sensitive: false }

    private
      # Converts email to all lower-case.
      def downcase_url
        self.url = url.downcase
      end

end
