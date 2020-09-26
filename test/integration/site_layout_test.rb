require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:michael)
    @nonadmin = users(:archer)
  end

  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", workouts_path
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", signup_path
    workoutlisted = Workout.all[dailypickfortesting]
    #workoutlisted = Workout.all.order("created_at desc").first
    assert_select 'iframe[src=?]', "#{workoutlisted.url}"

    get signup_path
    assert_template 'users/new'
    assert_select "title", "Sign up | Wack"

    log_in_as(@nonadmin)
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", signup_path, count: 0
    assert_select "a[href=?]", workouts_path
    assert_select "a[href=?]", user_path(@nonadmin)
    assert_select "a[href=?]", edit_user_path(@nonadmin)
    assert_select "a[href=?]", logout_path
    assert_select 'iframe[src=?]', "#{workoutlisted.url}"

    log_in_as(@admin)
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", signup_path, count: 0
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", workouts_path
    assert_select "a[href=?]", user_path(@admin)
    assert_select "a[href=?]", edit_user_path(@admin)
    assert_select "a[href=?]", logout_path
    assert_select 'iframe[src=?]', "#{workoutlisted.url}"
  end
end
