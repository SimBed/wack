require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = 'Wack'
  end

  test 'should get root' do
    get root_url
    assert_response :success
  end

  test 'should get home' do
    get root_path
    assert_response :success
    assert_select 'title', @base_title.to_s
  end

  # for kitchen utensils
  test 'should get new' do
    get kitchen_utensils_path
    assert_response :success
  end
end
