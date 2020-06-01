class MicropostsController < ApplicationController
  before_action :logged_in_user, only: :create
  before_action :set_micropost, only: :destroy
  before_action :correct_user_or_admin, only: :destroy

  def create
    #micropost_params[:workout_id] = session[:workout_id]
    #@micropost = current_user.microposts.build(micropost_params)
    @micropost = current_user.microposts.build(micropost_params)
    #||= instead of = so tests dont fail
    @micropost.workout_id ||= session[:workout_id]
    if @micropost.save
      flash[:success] = "Comment added!"
      redirect_to workout_path(@micropost.workout_id)
    else
      #workouts/show.html.erb view needs @workout and @microposts instance variables
      #these are established in the workout controller and lost on rerender of view
      #redirect sends a new request so the (workout) controller's method retriggered and instance variables reset
      #render doesn't send a new request and so the instance variables from the workout controller are lost
      #rendering provides the convenient error messages

      #redirect approach, works but convenience of error partial lost and probably ineffeicient, unnecessary request
      #flash[:warning] = "Comment not added!"
      #redirect_to workout_path(session[:workout_id])

      #reset instance variable and rerender approach . Not very DRY. Must be a better method.

      #if added for testing..wouldn't normally apply
      if @micropost.workout_id.nil?
          redirect_to root_url
      else
        @workout = Workout.find(@micropost.workout_id)
        @microposts = @workout.microposts.paginate(page: params[:page])
        #more simple but less helpful to user is to set microposts to blank following an error
        #@microposts=[]
        render 'workouts/show'
      end
    end
  end

  def destroy
     @micropost.destroy
     flash[:success] = "Comment deleted"
     #see rails tutorial listing 13.52. Sends back to previous URL. Previous code would send to workout show if deleted from user profile.
     redirect_to request.referrer || root_url
     #redirect_to workout_path(session[:workout_id])

   end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :workout_id)
    end

    def set_micropost
      @micropost = Micropost.find(params[:id])
    end

    # Before filters

    # Confirms the correct user.
    def correct_user
        redirect_to(root_url) unless current_user?(@micropost.user)
    end

    # Confirms the correct user or admin.
    def correct_user_or_admin
      redirect_to(root_url) unless (current_user?(@micropost.user) or (current_user && current_user.admin?))
    end
end
