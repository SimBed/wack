require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @admin = users(:michael)
    @nonadmin = users(:archer)
  end

  test 'profile display of other user for non-logged in user' do
    get user_path(@admin)
    assert_redirected_to root_url
  end

  test 'profile display of other user for nonadmin logged in user' do
    log_in_as(@nonadmin)
    get user_path(@admin)
    assert_redirected_to root_url
  end

  test 'profile display of other user for admin user' do
    log_in_as(@admin)
    get user_path(@nonadmin)
    assert_template 'users/show'
    assert_select 'title', full_title(@nonadmin.name)
    assert_select 'h4', text: @nonadmin.name.upcase
    assert_select 'div>img.gravatar'
    assert_match @nonadmin.microposts.count.to_s, response.body
    assert_select 'nav.pagination'
    pagy, microposts = pagy(@nonadmin.microposts, page: 1) 
    # @nonadmin.microposts.paginate(page: 1).each do |micropost|
    microposts.each do |micropost|
      assert_match micropost.content, response.body
      assert_select 'a', text: micropost.workout.name
      assert_select 'span', text: @nonadmin.name, count: 0
    end
  end
end
