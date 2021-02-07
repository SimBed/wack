require 'test_helper'

class SchedulingsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:lana)
    @scheduling = schedulings(:last)
    @scheduling_other = schedulings(:run)
  end

  test "should redirect index when not logged in" do
    get schedulings_path
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect create when not logged in" do
    # the olde approach doesn't work after app modification for automation of demo user schedulings
    # because even though this post itself fails, it will trigger the create_demo_scheduling method
    # after the redirect to login_url, which itself creates a new demo user scheduling
    #assert_no_difference 'Scheduling.count' do
      post schedulings_path, params: { scheduling: { name: "skiing" , start_time: @scheduling.start_time, user_id: @user.id}}
    #end
    assert_not flash.empty?
    assert_redirected_to login_url
    # alternative approach (old approach above no lnger works)
    assert Scheduling.all.where(name: "skiing").empty?
  end

  test "should redirect show when not logged in" do
    get scheduling_path(@scheduling)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch scheduling_path(@scheduling), params: { scheduling: { name: @scheduling.name,
                                              start_time: @scheduling.start_time } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_not Scheduling.all.where(name: "last").empty?
    # assert_no_difference 'Scheduling.count' do
      delete scheduling_path(@scheduling)
    # end
    assert_redirected_to login_url
    # alternative approach (old approach above no lnger works)
    assert_not Scheduling.all.where(name: "last").empty?
  end

  test "should redirect destroy for wrong scheduling" do
    log_in_as(@user)
    assert_no_difference 'Scheduling.count' do
      delete scheduling_path(@scheduling_other)
    end
    assert_redirected_to root_url
  end
end
