class SchedulingsController < ApplicationController
  before_action :set_scheduling, only: [:show, :edit, :update, :destroy]

  def index
    @schedulings = Scheduling.all
    @scheduling = current_user.schedulings.build()
  end

  def show
  end

  def new
    @scheduling = current_user.schedulings.build()
  end

  def create
    @scheduling = current_user.schedulings.build(scheduling_params)
    # the name of the scheduling is the same as the workout name and not a form item
    # workout_id is a hidden field
    # Schedule name is the name of the workout if set from Workouts Index
    # or given name in form if set from the Scheduling Index
    @scheduling.name ||= Workout.find(params[:workout_id]).name
    #||= instead of = so tests dont fail
    @scheduling.workout_id ||= params[:workout_id]
    if @scheduling.save
      #redirect_to workouts_path
      redirect_to request.referrer || root_url
      flash[:success] = "#{@scheduling.name} scheduled!"
      #redirect_to workout_path(@scheduling.workout_id)
    else
      if @scheduling.workout_id.nil?
          redirect_to root_url
      else
        @workout = Workout.find(@scheduling.workout_id)
        @attempts = @workout.attempts.paginate(page: params[:page])
        @microposts = @workout.microposts.paginate(page: params[:page])
        @micropost = current_user.microposts.build()

        render 'workouts/show'
      end
    end
  end

  def edit
  end

  def update
    if @scheduling.update_attributes(scheduling_params)
      flash[:success] = "Scheduling updated"
      redirect_to schedulings_path
    else
      render 'edit'
    end
  end

  def destroy
     @scheduling.destroy
     flash[:success] = "Scheduling deleted"
     #see rails tutorial listing 13.52.
     redirect_to request.referrer || root_url
   end

  private

    def scheduling_params
      params.require(:scheduling).permit(:name, :start_time, :workout_id)
    end

    # Before filters
    def set_scheduling
      @scheduling = Scheduling.find(params[:id])
    end

    def correct_user_or_admin
      redirect_to(root_url) unless (current_user?(@scheduling.user) or (current_user && current_user.admin?))
    end

end
