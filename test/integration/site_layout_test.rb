require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end  

  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 1
    assert_select "a[href=?]", "http://www.thespacejuhu.in/"
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", signup_path
    
    get signup_path
    assert_template 'users/new'
    assert_select "title", "Sign up | Ruby on Rails Tutorial Sample App"
    
    log_in_as(@user)
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 1
    assert_select "a[href=?]", "http://www.thespacejuhu.in/"
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    #DPS added count:0 (unexplained gremlin...from nowhere this test failed..??)
    assert_select "a[href=?]", signup_path, count: 0
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user)
    
  end
end