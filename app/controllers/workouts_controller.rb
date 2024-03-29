class WorkoutsController < ApplicationController
  before_action :initialize_sort, only: :index
  before_action :logged_in_user, only: [:show]
  before_action :set_workout, only: [:edit, :update, :destroy]
  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy]
  require 'cgi'
  def index
    # if a particular workout is added as a query parameter
    session[:search_name] = CGI.unescape params[:search_name] if params[:search_name]
    handle_favourites
    handle_search_name
    handle_advancedsearch
    # @workouts = @workouts.send("order_by_#{session[:sort_option]}").paginate(page: params[:page], per_page: 10)
    @pagy, @workouts = pagy(@workouts.send("order_by_#{session[:sort_option]}"))
    @intensity = Workout.distinct.pluck(:intensity).sort!
    @style = Workout.distinct.pluck(:style).sort!
    # sort bodyfocus not alphabetically but in anatomical order set in config/workoutinfo.yml
    # The || 100 is a default big number to avoid nils which cause the sort to break.
    # In theory there shouldn't be any nils.
    @bodyfocus = Workout.distinct.pluck(:bodyfocus).sort_by do |x|
      Rails.application.config_for(:workoutinfo)['bodyfocus'].find_index(x) || 100
    end
    if current_user
      @scheduling = current_user.schedulings.build
      @schedulings = current_user.schedulings.order_by_start_time
    end
    session[:linked_from] = :workout_index
    # list of workout names is needed for AJAX to identify the IDs of divs to add code
    # to for calendar update after scheduling creation. Cookies/sessions cannot be
    # larger than 4kb, so this approach is dangerous (storing an array in a session) and will not scale.
    # Eventually in production above a certain number of workouts, this may fail. Consider storing in a model.
    # Cookie values are String based. Other data types need to be serialized
    session[:workout_names] = JSON.generate(@workouts.map(&:name))
    session[:page] = params[:page] || 1
  end

  def show
    @workout = Workout.find(params[:id])
    # @microposts = @workout.microposts.paginate(page: params[:page])
    @pagy, @microposts = pagy(@workout.microposts)    
    @micropost = current_user.microposts.build
  end

  def new
    @workout = Workout.new
    @brand = Workout.distinct.pluck(:brand)
  end

  def create
    @workout = Workout.new(workout_params)
    @workout.addedby = current_user
    if @workout.save
      flash[:success] = "New workout, #{@workout.name} added!"
      redirect_to workouts_path
    else
      @brand = Workout.distinct.pluck(:brand)
      render :new
    end
  end

  def edit
    # if @brand doesn't exist the form can't be built, as it relies on @brand for populating a dropdown
    @brand = Workout.distinct.pluck(:brand)
  end

  def update
    if @workout.update(workout_params)
      flash[:success] = "#{@workout.name} updated"
      redirect_to workouts_path
    else
      @brand = Workout.distinct.pluck(:brand)
      render :edit
    end
  end

  def destroy
    @workout.destroy
    flash[:success] = "#{@workout.name} deleted"
    redirect_to workouts_path
  end

  # clear_session defined in sessions_helper.rb
  def clear
    clear_session(:filter_style, :filter_bodyfocus, :search_name)
    redirect_to workouts_path
  end

  def favourites
    # if not logged in then current_user.workouts will fail, so only available to loggedin users
    if current_user
      session[:favesonly] = false if session[:favesonly].nil?
      session[:favesonly] = !session[:favesonly]
    else
      handle_not_loggedin
    end
    redirect_to workouts_path
  end

  def search
    clear_session(:filter_style, :filter_bodyfocus, :search_name)
    # Without the ors (||) the sessions would get set to nil when redirecting to workouts other than through the
    # search form (e.g. by clicking workouts on the navbar) (as the params itmes are nil in these cases)
    session[:search_name] = params[:search_name] || session[:search_name]
    session[:filter_style] = params[:style] || session[:filter_style]
    # session[:filter_intensity] = params[:intensity] || session[:filter_intensity]
    session[:filter_bodyfocus] = params[:bodyfocus] || session[:filter_bodyfocus]
    session[:advsearchshow] = params[:advsearchshow] || session[:advsearchshow]
    filters = [session[:filter_style], session[:filter_bodyfocus]]
    redirect_to workouts_path
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def workout_params
    params.require(:workout).permit(:name, :style, :url, :length, :intensity, :spacesays, :brand, :equipment,
                                    :eqpitems, :bodyfocus, :short_name)
  end

  def set_workout
    @workout = Workout.find(params[:id])
  end

  def sort_column
    # params[:sort] || "name"
    Workout.column_names.include?(params[:sort]) ? params[:sort] : 'name'
  end

  def sort_direction
    # params[:direction] || "asc"
    # additional code provides robust sanitisation of what goes into the order clause
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

  def initialize_sort
    session[:sort_option] = params[:sort_option] || session[:sort_option] || 'date_created_desc'

    # session[:advsearchshow] = filters.any? { |filter| filter.present? }
    # session[:favesonly] is set through the favourties method
  end

  def handle_favourites
    @workouts = if session[:favesonly] == true
                  current_user.workouts
                else
                  Workout.all
                end
  end

  def handle_search_name
    return if session[:search_name].blank?

    # turn "HIIT core" into ["%hiit%", "%core%"]
    search_name_array = session[:search_name].split.map { |val| "%#{val}%" }
    @workouts = @workouts.where('name ILIKE ANY ( array[?] )', search_name_array)
                         .or(@workouts.where('brand ILIKE ANY ( array[?] )', search_name_array))
                         .or(@workouts.where('style ILIKE ANY ( array[?] )', search_name_array))
                         .or(@workouts.where('bodyfocus ILIKE ANY ( array[?] )', search_name_array))

    # previous approach with SQLITE in development and no multi-word search
    # ILIKE is case-insensitive version of LIKE but postgreql only (not sqlite) hence need for lower instead
    # original approach does not recognise multi-word searches,
    # so would fail to even find "HIIT" if "HIIT core" searched for
    # @workouts = @workouts.where("lower(name) LIKE ?", "%#{session[:search_name].downcase}%")
    #         .or(@workouts.where("lower(brand) LIKE ?", "%#{session[:search_name].downcase}%"))
    #         .or(@workouts.where("lower(style) LIKE ?", "%#{session[:search_name].downcase}%"))
    #         .or(@workouts.where("lower(bodyfocus) LIKE ?", "%#{session[:search_name].downcase}%"))
  end

  def handle_advancedsearch
    @workouts = @workouts.where(style: session[:filter_style]) if session[:filter_style].present?
    # @workouts = @workouts.where(intensity: session[:filter_intensity]) if session[:filter_intensity].present?
    @workouts = @workouts.where(bodyfocus: session[:filter_bodyfocus]) if session[:filter_bodyfocus].present?
  end

  def handle_not_loggedin
    message = 'Please sign up for this feature.'
    flash[:warning] = message
  end
end
