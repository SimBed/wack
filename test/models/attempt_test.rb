require 'test_helper'

class AttemptTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    @workout = workouts(:workouttwo)
    @attempt = @user.attempts.build(doa: "5/6/2020", summary: "felt tired today", workout_id: @workout.id)
  end

  test "should be valid" do
    assert @attempt.valid?
  end

  test "user id should be present" do
   @attempt.user_id = nil
   assert_not @attempt.valid?
 end

 test "workout id should be present" do
  @attempt.workout_id = nil
  assert_not @attempt.valid?
end

 test "summary does not have to be present" do
   @attempt.summary = "   "
   assert @attempt.valid?
 end

 test "summary should be at most 140 characters" do
   @attempt.summary = "a" * 141
   assert_not @attempt.valid?
 end

 test "order should be most recent first" do
     assert_equal attempts(:most_recent), Attempt.first
 end
end
