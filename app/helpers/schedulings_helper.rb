module SchedulingsHelper
  # a scheduling show can be viewed from 3 places. Returns the correct place to go back to.
  # using a hash is a nicer alternative to case...when
  def scheduling_back
      links = {
      'welcome': root_path,
      'schedulings_index': schedulings_path,
      'workout_index': session[:wk_url]
    }
    # session[:linked_from] is set in the index metods of Workouts and Schedulings
    # Controller and home method of Static_Pages Controller
    links[session[:linked_from].to_sym]
  end
end
