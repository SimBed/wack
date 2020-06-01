require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @micropost = microposts(:brillo) #belongs to nonadmin lana
    @nonadmin = users(:archer)
    @admin = users(:michael)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "Lorem ipsum", user_id: 1, workout_id: 2 } }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
      assert_redirected_to root_url
  end

  test "should redirect destroy for wrong micropost" do
    log_in_as(@nonadmin)
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to root_url
  end

end
