module SchedulingsHelper
  # a scheduling show can be viewed from 3 places. Returns the correct place to go back to.
  # using a hash is a nicer alternative to case...when
  def scheduling_back
    links = {
      'welcome': root_path,
      'schedulings': schedulings_path,
      'workout_index': workouts_path
    }
    links[session[:linked_from].to_sym]
  end
end
