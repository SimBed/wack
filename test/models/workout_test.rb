require 'test_helper'

class WorkoutTest < ActiveSupport::TestCase
  def setup
    @workout = Workout.new(name: "Example Workout", style: "Cardio",url: "www.example.com", length: 30, intensity: "High")
  end

  test "should be valid" do
    assert @workout.valid?
  end

  test "name should be present" do
    @workout.name = "     "
    assert_not @workout.valid?
  end

  test "name should not be too long" do
    @workout.name = "a" * 51
    assert_not @workout.valid?
  end

  test "url should not be too long" do
    @workout.url = "www." + ("a" * 248) + ".com"
    assert_not @workout.valid?
  end

  test "url validation should accept valid addresses" do
    valid_addresses = %w[www.example.com WWW.EXAMPLE.com www.ex_am_ple.in]
    valid_addresses.each do |valid_address|
      @workout.url = valid_address
      assert @workout.valid?, "#{valid_address.inspect} should be valid"
    end
  end

=begin
  test "url validation should reject invalid addresses" do
    invalid_addresses = %w[ww.example.com www.example]
    invalid_addresses.each do |invalid_address|
      @workout.url = invalid_address
      assert_not @workout.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
=end

  test "name should be unique" do
    duplicate_workout = @workout.dup
    duplicate_workout.name = @workout.name.upcase
    #wihtout changing the url the test will pass at least on account of url uniqueness requirement
    duplicate_workout.url = "www.exxxample.com"
#cant understand why this code wont work. The code seems to work but the test passes when it should fail.
   #duplicate_workout.url = @workout.url.insert(8,'xx')
    @workout.save
    assert_not duplicate_workout.valid?
  end

  test "url should be unique" do
    duplicate_workout = @workout.dup
    duplicate_workout.url = @workout.url.upcase
    @workout.save
    assert_not duplicate_workout.valid?
  end

=begin
  test "url addresses should be saved as lower-case" do
    mixed_case_url = "WWW.EXamPLE.Com"
    @workout.url = mixed_case_url
    @workout.save
    assert_equal mixed_case_url.downcase, @workout.reload.url
=end

end
