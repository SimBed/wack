class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include StaticPagesHelper
  include SchedulingsHelper
  before_action :create_demo_scheduling

  private

    def create_demo_scheduling
      if nothing_scheduled? && workout_day? && logged_in?
        random_workout = Workout.all[dailypick(6)]
        start_time = Time.now().beginning_of_day - 0.day + 6.day + 10 * 60 * 60
        User.find_by(demo: true).schedulings.build(name: random_workout.name_for_cal, start_time: start_time, workout_id: random_workout.id).save
      end
    end

    def nothing_scheduled?
      Time.now().beginning_of_day - 0.day + 6.day > User.find_by(demo: true).schedulings.last.start_time.beginning_of_day
    end

    def workout_day?
      [1, 3, 5, 6].include?((Date.today() - 0.day + 6.day).wday)
    end

      # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless (current_user && current_user.admin?)
    end

    # Confirms a logged-in user, but not demo.
    def logged_in_as_real_user
      unless logged_in_as_real_user? # sessions_helper.rb
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in? # sessions_helper.rb
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # not used
    def session_workout_names
      JSON.parse(session[:workout_names])
    end

end
