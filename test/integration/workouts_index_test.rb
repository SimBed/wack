require 'test_helper'
include Pagy::Backend

class WorkoutsIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin     = users(:michael)
    @non_admin = users(:archer)
    @workout2 = workouts(:workout2)
  end

  test 'index as admin including pagination and delete links' do
    log_in_as(@admin)
    get workouts_path
    assert_template 'workouts/index'
    assert_select 'nav.pagination'
    # first_page_of_workouts = Workout.all.paginate(page: 1, per_page: 5)
    pagy, first_page_of_workouts = pagy(Workout.all, page: 1, per_page: 5)    
    first_page_of_workouts.each do |workout|
      assert_select 'h4', workout.name.upcase.to_s
      assert_select 'iframe[src=?]', "#{workout.url}?modestbranding=1"
      assert_select 'a[href=?]', workout_path(workout), text: 'Delete'
    end
    assert_difference 'Workout.count', -1 do
      delete workout_path(@workout2)
    end
  end

  test 'index as nonadmin' do
    log_in_as(@non_admin)
    get workouts_path
    assert_template 'workouts/index'
    assert_select 'nav.pagination'
    # first_page_of_workouts = Workout.all.paginate(page: 1, per_page: 5)
    pagy, first_page_of_workouts = pagy(Workout.all, page: 1, per_page: 5)        
    first_page_of_workouts.each do |workout|
      assert_select 'iframe[src=?]', "#{workout.url}?modestbranding=1"
      assert_select 'a[href=?]', workout_path(workout), count: 2
    end
    assert_no_difference 'Workout.count' do
      delete workout_path(@workout2)
    end
  end
end
