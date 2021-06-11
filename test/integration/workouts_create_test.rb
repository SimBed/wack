require 'test_helper'

class WorkoutsCreateTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:michael)
    @nonadmin = users(:archer)
  end

  test 'invalid input for new workout (admin)' do
    log_in_as(@admin)
    assert_no_difference 'Workout.count' do
      post workouts_path, params: { workout: { name: '',
                                               url: 'wwwinvalid',
                                               style: 'Yoga',
                                               length: '75',
                                               intensity: 'High',
                                               brand: 'myBrand' } }
    end
    assert_template 'workouts/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test 'valid input for new workout (admin)' do
    log_in_as(@admin)
    assert_difference 'Workout.count', 1 do
      post workouts_path, params: { workout: { name: 'testworkout',
                                               url: 'www.testvalid.com',
                                               style: 'Yoga',
                                               length: '75',
                                               intensity: 'High',
                                               brand: 'myBrand' } }
    end
    follow_redirect!
    assert_template 'workouts/index'
    assert_not flash.empty?
  end

  test 'valid input for new workout (non-admin)' do
    log_in_as(@nonadmin)
    assert_difference 'Workout.count', 0 do
      post workouts_path, params: { workout: { name: 'testworkout',
                                               url: 'www.testvalid.com',
                                               style: 'Yoga',
                                               length: '75',
                                               intensity: 'High',
                                               brand: 'myBrand' } }
    end
    assert_redirected_to root_url
    assert flash.empty?
  end
end
