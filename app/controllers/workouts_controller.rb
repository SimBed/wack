class WorkoutsController < ApplicationController
  before_action :initialize_search, only: :index
  before_action :logged_in_user, only: [:show]
  before_action :set_workout, only: [:edit, :update, :destroy]
  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy]

  def index
    #@workouts = Workout.paginate(page: params[:page])
    #@workouts = Workout.all.order(sort_column + " " + sort_direction, :name).paginate(page: params[:page],per_page: 10)
    handle_search_name
    handle_filters
  end

  def show
    @workout = Workout.find(params[:id])
    session[:workout_id]=@workout.id
    @microposts = @workout.microposts.paginate(page: params[:page])
    @micropost = current_user.microposts.build()
  end

  def new
    @workout = Workout.new
  end

  def create
    @workout = Workout.new(workout_params)
    @workout.addedby = current_user
    if @workout.save
      redirect_to workouts_path
      flash[:success] = "New workout, #{@workout.name} added!"
    else
      render :new
    end
  end

  def edit
    #set_workout occurs via callback
  end

  def update
    #set_workout occurs via callback
    if @workout.update(workout_params)
      flash[:success] = "#{@workout.name} updated"
      redirect_to workouts_path
    else
      render :edit
    end
  end

  def destroy
    #set_workout occurs via callback
    @workout.destroy
    flash[:success] = "#{@workout.name} deleted"
    redirect_to workouts_path
  end

  def clear
    clear_session(:search_name, :filter_name, :filter)
    redirect_to workouts_path
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def workout_params
    params.require(:workout).permit(:name, :style, :url, :length, :intensity, :spacesays, :brand, :equipment, :eqpitems)
  end

  def set_workout
    @workout = Workout.find(params[:id])
  end

  def sort_column
    #params[:sort] || "name"
    Workout.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    #params[:direction] || "asc"
    #additional code provides robust sanitisation of what goes into the order clause
    %w[asc desc].include?(params[:direction]) ? params[:direction]  : "asc"
  end

  def initialize_search
    #@workouts = Workout.alphabetical
    #session[:search_name] ||= params[:search_name]
    session[:search_name] = params[:search_name]
    session[:filter] = params[:filter]
    params[:filter_option] = nil if params[:filter_option] == ""
    session[:filter_option] = params[:filter_option]
  end

  def handle_search_name
    if session[:search_name]
      @workouts = Workout.where("name LIKE ?", "%#{session[:search_name].titleize}%").paginate(page: params[:page],per_page: 10)
      #@teams = @teams.where(code: @players.pluck(:team))
    else
      @workouts = Workout.all.paginate(page: params[:page],per_page: 10)
    end
  end

  def handle_filters
    if session[:filter_option] && session[:filter] == "style"
      @workouts = @workouts.where(style: session[:filter_option]).paginate(page: params[:page],per_page: 10)
      #@teams = @teams.where(code: @players.pluck(:team))
    elsif session[:filter_option] && session[:filter] == "intensity"
      @workouts = @workouts.where(intensity: session[:filter_option]).paginate(page: params[:page],per_page: 10)
    end
  end

end
