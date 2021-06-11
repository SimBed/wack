require 'test_helper'

class WorkoutsEditTest < ActionDispatch::IntegrationTest
  def setup
    @admin     = users(:michael)
    @non_admin = users(:archer)
    @workout = workouts(:workoutone)
  end

  test 'edit as non-admin' do
    log_in_as(@non_admin)
    get edit_workout_path(@workout)
    assert_response :redirect
  end

  test 'update with valid input as non-admin' do
    patch workout_path(@workout), params: { workout: { name: 'testworkout',
                                                       url: 'www.testvalid.com',
                                                       style: 'Yoga',
                                                       length: '75',
                                                       intensity: 'High',
                                                       brand: 'myBrand2' } }
    assert_response :redirect
  end

  test 'unsuccessful edit as admin' do
    log_in_as(@admin)
    get edit_workout_path(@workout)
    assert_template 'workouts/edit'
    patch workout_path(@workout), params: { workout: { name: '',
                                                       url: 'wwwinvalid',
                                                       style: 'Yoga',
                                                       length: '75',
                                                       intensity: 'High',
                                                       brand: 'myBrand2' } }

    assert_template 'workouts/edit'
    assert_select 'div.alert.alert-danger'
  end

  test 'successful edit as admin' do
    log_in_as(@admin)
    name = 'testworkout'
    url = 'www.testvalid.com'
    intensity = @workout.intensity
    brand = @workout.brand
    patch workout_path(@workout), params: { workout: { name: name,
                                                       url: url } }
    assert_not flash.empty?
    assert_redirected_to workouts_path
    @workout.reload
    assert_equal name, @workout.name
    assert_equal url, @workout.url
    assert_equal intensity, @workout.intensity
    assert_equal brand, @workout.brand
  end
end
