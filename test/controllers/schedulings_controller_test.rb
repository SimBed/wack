require 'test_helper'

class SchedulingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get schedulings_url
    assert_response :success
  end
end
