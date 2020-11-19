require 'test_helper'
require 'time'

class SchedulingTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    @workout = workouts(:workouttwo)
    # mimics creating the scheduling from the Workouts Index
    @scheduling1 = @user.schedulings.build(name: @workout.name, start_time: Time.now().advance(hours: 1), workout_id: @workout.id)
    # mimics creating the scheduling from the Schedulings Index
    @scheduling2 = @user.schedulings.build(name: "run", start_time: Time.now().advance(days: 1))
    # @schedulings = Scheduling.all.order_by_start_time
  end

  test "should be valid" do
    assert @scheduling1.valid?
    assert @scheduling2.valid?
  end

  test "name should be present" do
   @scheduling1.name = nil
   assert_not @scheduling1.valid?
  end

  test "start time should be present" do
   @scheduling1.start_time = nil
   assert_not @scheduling1.valid?
  end

  test "must have an associated user" do
   @scheduling1.user_id = nil
   assert_not @scheduling1.valid?
  end

  test "order should be earliest first when order_by_start_time scope applied" do
   assert_equal schedulings(:next_up), Scheduling.order_by_start_time.first
  end
end
