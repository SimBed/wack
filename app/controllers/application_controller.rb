class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include Pagy::Backend
  include SessionsHelper
  include StaticPagesHelper
  include SchedulingsHelper
  before_action :create_demo_scheduling

  private

  def create_demo_scheduling
    return unless scheduling_needed?

    random_workout = Workout.all[dailypick(6)]
    start_time = Time.zone.now.beginning_of_day + 6.days + 36_000
    demo_user.schedulings.build(name: random_workout.name_for_cal, start_time: start_time,
                                workout_id: random_workout.id).save
  end

  def scheduling_needed?
    nothing_scheduled? && workout_day? && logged_in?
  end

  def demo_user
    User.find_by(demo: true)
  end

  def nothing_scheduled?
    Time.zone.now.beginning_of_day + 6.days > demo_user.schedulings.last.start_time.beginning_of_day
  end

  def workout_day?
    [1, 3, 5, 6].include?((Time.zone.today + 6.days).wday)
  end

  def admin_user
    redirect_to(root_url) unless current_user&.admin?
  end

  # Confirms a logged-in user, but not demo.
  def logged_in_as_real_user
    return if logged_in_as_real_user? # sessions_helper.rb

    store_location
    flash[:danger] = 'Please log in.'
    redirect_to login_url
  end

  # Confirms a logged-in user.
  def logged_in_user
    return if logged_in? # sessions_helper.rb

    store_location
    flash[:danger] = 'Please log in.'
    redirect_to login_url
  end
end
