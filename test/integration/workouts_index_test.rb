require 'test_helper'

class WorkoutsIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin     = users(:michael)
    @non_admin = users(:archer)
    @workout2 = workouts(:workout_2)
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get workouts_path
    assert_template 'workouts/index'
    assert_select 'div.pagination'
    first_page_of_workouts = Workout.all.paginate(page: 1,per_page: 10)
    first_page_of_workouts.each do |workout|
      assert_select 'h4', "#{workout.name}"
      assert_select 'iframe[src=?]', "#{workout.url}"
      assert_select 'a[href=?]', workout_path(workout), text: 'Delete'
    end
    assert_difference 'Workout.count', -1 do
      delete workout_path(@workout2)
    end
  end

  test "index as nonadmin" do
    log_in_as(@non_admin)
    get workouts_path
    assert_template 'workouts/index'
    assert_select 'div.pagination'
    first_page_of_workouts = Workout.all.paginate(page: 1,per_page: 10)
    first_page_of_workouts.each do |workout|
      assert_select 'iframe[src=?]', "#{workout.url}"
      assert_select 'a[href=?]', workout_path(workout), count: 0
    end
    assert_no_difference 'Workout.count' do
      delete workout_path(@workout2)
    end
  end

end
