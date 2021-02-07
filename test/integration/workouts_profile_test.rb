require 'test_helper'

class WorkoutsProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @admin = users(:michael)
    @nonadmin = users(:archer)
    @workout = workouts(:workouttwo)
  end

  test "workout display for non-logged in user" do
    get workout_path(@workout)
    assert_template 'workouts/show'
    # assert_redirected_to login_url
  end

  test "workout display for non-admin " do
    log_in_as(@nonadmin)
    get workout_path(@workout)
    assert_template 'workouts/show'
    assert_select 'title', full_title(@workout.name)
    assert_select 'h4', text: @workout.name.upcase
    # assert_select 'form.new_micropost'
    assert_select 'form'
    assert_select 'iframe[src=?]', "#{@workout.url}"
    assert_select 'a[href=?]', workout_path(@workout)
    assert_select 'a[href=?]', workout_path(@workout), text: 'Delete', count:0
    #improved test for the admin below but retained this for posterity
    assert_match @workout.microposts.count.to_s, response.body

    @workout.microposts.paginate(page: 1).each do |micropost|
      assert_select 'a', text: micropost.user.name
      assert_select 'a', text: @workout.name
      assert_match micropost.content, response.body
      if micropost.user == @nonadmin
        assert_select 'a[href=?]', micropost_path(micropost), count:1
      else
        assert_select 'a[href=?]', micropost_path(micropost), count:0
      end
    end
  end

  test "workout display for admin " do
    log_in_as(@admin)
    get workout_path(@workout)
    assert_template 'workouts/show'
    assert_select 'title', full_title(@workout.name)
    assert_select 'h4', text: @workout.name.upcase
    assert_select 'iframe[src=?]', "#{@workout.url}"
    assert_select 'a[href=?]', workout_path(@workout)
    assert_select 'a[href=?]', workout_path(@workout), text: 'Delete', count:1
    assert_select 'h3', text: "#PeopleofTheSpace say... (#{@workout.microposts.count.to_s})"
    #assert_select 'div.pagination'
    @workout.microposts.paginate(page: 1).each do |micropost|
      assert_select 'a', text: micropost.user.name
      assert_select 'a', text: @workout.name
      assert_match micropost.content, response.body
      assert_select 'a[href=?]', micropost_path(micropost), count:1
    end
  end
end
