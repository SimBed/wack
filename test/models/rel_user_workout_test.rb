require 'test_helper'

class RelUserWorkoutTest < ActiveSupport::TestCase
  def setup
    @reluserworkout = RelUserWorkout.new(user_id: users(:michael).id,
                                         workout_id: workouts(:workoutone).id)
  end

  test 'should be valid' do
    assert @reluserworkout.valid?
  end

  test 'should require a user_id' do
    @reluserworkout.user_id = nil
    assert_not @reluserworkout.valid?
  end

  test 'should require a workout_id' do
    @reluserworkout.workout_id = nil
    assert_not @reluserworkout.valid?
  end
end
