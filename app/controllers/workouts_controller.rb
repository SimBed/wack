class WorkoutsController < ApplicationController
  before_action :initialize_search, only: :index
  before_action :logged_in_user, only: [:show]
  before_action :set_workout, only: [:edit, :update, :destroy]
  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy]

  def index
    #@test = session[:filter_style][1]
    #@test = params['style[1]']
    #@workouts = Workout.paginate(page: params[:page])
    #@workouts = Workout.all.order(sort_column + " " + sort_direction, :name).paginate(page: params[:page],per_page: 10)
    handle_favourites
    handle_search_name
    handle_advancedsearch
    @workouts = @workouts.order_by_date_created.paginate(page: params[:page],per_page: 5)
    #if Rails.env.development?
    @intensity = Workout.distinct.pluck(:intensity)
    @style = Workout.distinct.pluck(:style)
    @bodyfocus = Workout.distinct.pluck(:bodyfocus)
    #@intensity = Workout.pluck(:intensity).uniq
    #@style = Workout.pluck(:style).uniq

  end

  def show
    @workout = Workout.find(params[:id])
    session[:workout_id]=@workout.id
    @microposts = @workout.microposts.paginate(page: params[:page])
    @micropost = current_user.microposts.build()
    @attempt = current_user.attempts.build()
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
    #at one point this was just "update" not "update_attributes". SQLite was OK but posgres didnt like it. No idea how it got like that??
    if @workout.update_attributes(workout_params)
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

#clear_session defined in sessions_helper.rb
  def clear
    clear_session(:search_name, :favesonly)
    redirect_to workouts_path
  end


  def favourites
    session[:favesonly] = false if session[:favesonly].nil?
    session[:favesonly] = !session[:favesonly]
    redirect_to workouts_path
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def workout_params
    params.require(:workout).permit(:name, :style, :url, :length, :intensity, :spacesays, :brand, :equipment, :eqpitems, :bodyfocus)
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
    #clear_session defined in sessions_helper.rb clears out the sessions. Without this an empty checkbox may not necessarily mean an empty session
    clear_session(:filter_style, :filter_intensity, :filter_bodyfocus)
    session[:search_name] = params[:search_name]
#    session[:filter] = params[:filter]
#    params[:filter_option] = nil if params[:filter_option] == ""
    session[:filter_style] = params[:style]
    session[:filter_intensity] = params[:intensity]
    session[:filter_bodyfocus] = params[:bodyfocus]
    filters = [session[:filter_style], session[:filter_intensity], session[:filter_bodyfocus] ]
    session[:advsearchshow] = filters.any? { |filter| filter.present? }
  end

  def handle_favourites
    if session[:favesonly] == true
      @workouts = current_user.workouts
    else
      @workouts = Workout.all
    end
  end

  def handle_search_name
    if session[:search_name]
      #ILIKE is case-insensitive version of LIKE but postgreql only (not sqlite)
      @workouts = @workouts.where("lower(name) LIKE ?", "%#{session[:search_name].downcase}%")
              .or(@workouts.where("lower(brand) LIKE ?", "%#{session[:search_name].downcase}%"))
              .or(@workouts.where("lower(style) LIKE ?", "%#{session[:search_name].downcase}%"))
              .or(@workouts.where("lower(bodyfocus) LIKE ?", "%#{session[:search_name].downcase}%"))
    end
  end

  def handle_advancedsearch
    @workouts = @workouts.where(style: session[:filter_style]) if session[:filter_style].present?
    @workouts = @workouts.where(intensity: session[:filter_intensity]) if session[:filter_intensity].present?
    @workouts = @workouts.where(bodyfocus: session[:filter_bodyfocus]) if session[:filter_bodyfocus].present?
  end

end
