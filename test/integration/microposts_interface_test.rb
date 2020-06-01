require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @micropost = microposts(:brillo) #belongs to nonadmin lana and workouttwo
    @workout = workouts(:workouttwo)
    @admin = users(:michael)
    @nonadmin = users(:archer)
   end

   test "micropost interface as nonadmin" do
     log_in_as(@nonadmin)
     get workouts_path(@workout)
     # Invalid submission
     assert_no_difference 'Micropost.count' do
       #empty content
       post microposts_path, params: { micropost: { content: "", workout_id: 289898658 } }
     end
     assert_select 'div#error_explanation'
     # Valid submission
     content = "A great workout for a test"
     assert_difference 'Micropost.count', 1 do
       #established this weird workout_id for workouttwo by going into the console
       post microposts_path, params: { micropost: { content: content, workout_id: 289898658 } }
     end
     assert_redirected_to workout_url(@workout)
     follow_redirect!
     assert_match content, response.body
     # Delete the post
     first_micropost = @workout.microposts.paginate(page: 1).first
     assert_difference '@workout.microposts.count', -1 do
       delete micropost_path(first_micropost)
     end
     # Delete the next post (which won't be Archer's)
     first_micropost = @workout.microposts.paginate(page: 1).first
     assert_difference '@workout.microposts.count', 0 do
       delete micropost_path(first_micropost)
     end
   end

   test "micropost interface as admin" do
     log_in_as(@admin)
     # Invalid submission
     assert_no_difference 'Micropost.count' do
       #empty content
       post microposts_path, params: { micropost: { content: "", workout_id: 289898658 } }
     end
     assert_select 'div#error_explanation'
     # Valid submission
     content = "A great workout for a test"
     assert_difference 'Micropost.count', 1 do
       post microposts_path, params: { micropost: { content: content, workout_id: 289898658 } }
     end
     assert_redirected_to workout_url(@workout)
     follow_redirect!
     assert_match content, response.body
     # Delete the post
     first_micropost = @workout.microposts.paginate(page: 1).first
     assert_difference '@workout.microposts.count', -1 do
       delete micropost_path(first_micropost)
     end

     #add a post by non-admin to be sure we are testing deleting ad ifferent user's post
     log_in_as(@nonadmin)
    post microposts_path, params: { micropost: { content: content, workout_id: 289898658 } }

     log_in_as(@admin)
     #have admin delete the last post by nonadmin
     first_micropost = @workout.microposts.paginate(page: 1).first
     assert_difference '@workout.microposts.count', - 1 do
       delete micropost_path(first_micropost)
     end
   end
end
