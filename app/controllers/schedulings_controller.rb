class SchedulingsController < ApplicationController
  before_action :logged_in_as_real_user, only: [:create, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:show]
  before_action :set_scheduling, only: [:show, :edit, :update, :destroy]
  require 'cgi'

  def index
    @schedulings = current_user.schedulings.order_by_start_time
    @scheduling = current_user.schedulings.build
    session[:linked_from] = :schedulings_index
  end

  def show
    unless @scheduling.workout_id.nil?
      @workout = Workout.find(@scheduling.workout_id)
      @microposts = @workout.microposts.paginate(page: params[:page])
      @micropost = current_user.microposts.build
    end
    session[:wk_url] = params[:wk_url]
  end

  def create
    scheduling_build
    if @scheduling.save
      set_instances
      ajax_respond
    elsif @scheduling.workout_id.nil?
      redirect_to root_url
    else
      reset_instances_after_fail
      render 'workouts/show'
    end
  end

  def edit; end

  def update
    if @scheduling.update(scheduling_params)
      flash[:success] = 'Scheduling updated'
      redirect_to @scheduling
    else
      render 'edit'
    end
  end

  def destroy
    @scheduling.destroy
    @schedulings = current_user.schedulings.order_by_start_time
    respond_to do |format|
      format.html do
        flash[:success] = 'Scheduling deleted'
        redirect_to schedulings_path
      end
      format.js { flash.now[:success] = "#{@scheduling.name} deleted" }
    end
  end

  private

  def scheduling_params
    params.require(:scheduling).permit(:name, :start_time, :workout_id)
  end

  def scheduling_build
    @scheduling = current_user.schedulings.build(scheduling_params)
    # a scheduling can be created from 2 places:
    # 1. from the Workouts index page, in which case the name of the scheduling
    # is set as the same name as the corresponding workout [update: the workout's short name]
    # (the name can not be edited on the form and workout_id is a hidden field in the form)
    # 2. from the Schedulings index, in which case the user can give the scheduling any name and workout_id is nil
    # name_for_cal returns the short name for the Workout if there is one (defined in workouts model)
    @scheduling.name ||= Workout.find(params[:workout_id]).name_for_cal
    # ||= instead of = so tests dont fail
    @scheduling.workout_id ||= params[:workout_id]
  end

  def set_instances
    # the js.erb needs to know whether the form submission came from the scheduling or
    # workout index as the calendars are shown differently in each place (bi-weekly/monthly)
    # session[:linked_from] set in index method
    @days_display = session[:linked_from] == 'schedulings_index' ? 28 : 14
    # params[:wk_url] passed when schedule_calendar partial called from workout partial
    @wk_url = params[:wk_url]
    # see application controller - session_workout_names method not used
    # reverse the JSON-isation from the index method of workouts controller
    # needed to store an array (of the workout names) in a cookie
    @workout_names = JSON.parse session[:workout_names] if session[:workout_names]
    @schedulings = current_user.schedulings.order_by_start_time
  end

  def ajax_respond
    respond_to do |format|
      format.html do
        flash[:success] = "#{@scheduling.name} scheduled!"
        redirect_to request.referer
      end
      format.js { flash.now[:success] = "#{@scheduling.name} scheduled!" }
    end
  end

  def reset_instances_after_fail
    @workout = Workout.find(@scheduling.workout_id)
    @attempts = @workout.attempts.paginate(page: params[:page])
    @microposts = @workout.microposts.paginate(page: params[:page])
    @micropost = current_user.microposts.build
  end

  # Before filter
  def set_scheduling
    @scheduling = Scheduling.find(params[:id])
    @user = User.find(@scheduling.user_id)
    # can't have users interfering with other users schedulings
    return if current_user?(@user)

    flash[:danger] = 'No access.'
    redirect_to(root_url)
  end

  # not used
  def correct_user_or_admin
    redirect_to(root_url) unless current_user?(@scheduling.user) || current_user&.admin?
  end
end
