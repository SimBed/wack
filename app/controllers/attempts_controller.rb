class AttemptsController < ApplicationController
  before_action :logged_in_user, only: :create
  before_action :set_attempt, only: :destroy
  before_action :correct_user_or_admin, only: :destroy

  def create
    @attempt = current_user.attempts.build(attempt_params)
    #||= instead of = so tests dont fail
    @attempt.workout_id ||= session[:workout_id]
    if @attempt.save
      flash[:success] = "Attempt added!"
      redirect_to workout_path(@attempt.workout_id)
    else
      if @attempt.workout_id.nil?
          redirect_to root_url
      else
        @workout = Workout.find(@attempt.workout_id)
        @attempts = @workout.attempts.paginate(page: params[:page])
        @microposts = @workout.microposts.paginate(page: params[:page])
        @micropost = current_user.microposts.build()

        render 'workouts/show'
      end
    end
  end

  def destroy
     @attempt.destroy
     flash[:success] = "Comment deleted"
     #see rails tutorial listing 13.52.
     redirect_to request.referrer || root_url
   end

  private

    def attempt_params
      params.require(:attempt).permit(:doa, :summary, :workout_id)
    end

    # Before filters

    def set_attempt
      @attempt = Attempt.find(params[:id])
    end

    def correct_user
        redirect_to(root_url) unless current_user?(@attempt.user)
    end

    def correct_user_or_admin
      redirect_to(root_url) unless (current_user?(@attempt.user) or (current_user && current_user.admin?))
    end
end
