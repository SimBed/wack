class WorkoutsController < ApplicationController
  before_action :initialize_sort, only: :index
  before_action :logged_in_user, only: [:show]
  before_action :set_workout, only: [:edit, :update, :destroy]
  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy]
require 'cgi'
  def index
    #if a particular workout is added as a query parameter
    session[:search_name] = CGI.unescape params[:search_name] if params[:search_name]
    handle_favourites
    handle_search_name
    handle_advancedsearch
    @workouts = @workouts.send("order_by_#{session[:sort_option]}").paginate(page: params[:page],per_page: 10)
    @intensity = Workout.distinct.pluck(:intensity).sort!
    @style = Workout.distinct.pluck(:style).sort!
    #sort bodyfocus not alphabetically but in anatomical order set in config/workoutinfo.yml
    #The || 100 is a default big number to avoid nils which cause the sort to break. In thoery there shouldn't be any nils.
    @bodyfocus = Workout.distinct.pluck(:bodyfocus).sort_by{|x| Rails.application.config_for(:workoutinfo)["bodyfocus"].find_index(x) || 100 }
    #@intensity = Workout.pluck(:intensity).uniq
    #@style = Workout.pluck(:style).uniq
    #@test = session[:filter_style][1]
    #@test = params['style[1]']
    #@workouts = Workout.paginate(page: params[:page])
    #@workouts = Workout.all.order(sort_column + " " + sort_direction, :name).paginate(page: params[:page],per_page: 10)
    @scheduling = current_user.schedulings.build()
    @schedulings = current_user.schedulings
  end

  def show
    @workout = Workout.find(params[:id])
    #session[:workout_id]=@workout.id
    @microposts = @workout.microposts.paginate(page: params[:page])
    @micropost = current_user.microposts.build()
    @attempt = current_user.attempts.build()
    #@scheduling = current_user.schedulings.build()
    #@schedulings = current_user.schedulings
  end

  def new
    @workout = Workout.new
    @brand = Workout.distinct.pluck(:brand)
  end

  def create
    @workout = Workout.new(workout_params)
    @workout.addedby = current_user
    if @workout.save
      redirect_to workouts_path
      flash[:success] = "New workout, #{@workout.name} added!"
    else
      #required instance variables are lost on re-render - see notes in create of MicropostsController
      @brand = Workout.distinct.pluck(:brand)
      render :new
    end
  end

  def edit
    #set_workout occurs via callback
    #if @brand doesn't exist the form can't be built, as it relies on @brand for populating a dropdown
    @brand = Workout.distinct.pluck(:brand)
  end

  def update
    #set_workout occurs via callback
    #at one point this was just "update" not "update_attributes". SQLite was OK but posgres didnt like it. No idea how it got like that??
    if @workout.update_attributes(workout_params)
      flash[:success] = "#{@workout.name} updated"
      redirect_to workouts_path
    else
      @brand = Workout.distinct.pluck(:brand)
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
    clear_session(:filter_style, :filter_intensity, :filter_bodyfocus, :search_name)
    redirect_to workouts_path
  end

  def favourites
    #if not logged in then current_user.workouts will fail, so only available to loggedin users
    if current_user
      session[:favesonly] = false if session[:favesonly].nil?
      session[:favesonly] = !session[:favesonly]
    else
      handle_not_loggedin
    end
      redirect_to workouts_path
  end

  def search
    clear_session(:filter_style, :filter_intensity, :filter_bodyfocus, :search_name)
    #Without the ors (||) the sessions would get set to nil when redirecting to workouts other than through the
    #search form (e.g. by clicking workouts on the navbar) (as the params itmes are nil in these cases)
    session[:search_name] = params[:search_name] || session[:search_name]
    session[:filter_style] = params[:style] || session[:filter_style]
    session[:filter_intensity] = params[:intensity] || session[:filter_intensity]
    session[:filter_bodyfocus] = params[:bodyfocus] || session[:filter_bodyfocus]
    session[:advsearchshow] = params[:advsearchshow] || session[:advsearchshow]
    filters = [session[:filter_style], session[:filter_intensity], session[:filter_bodyfocus] ]
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

  def initialize_sort
    session[:sort_option] = params[:sort_option] || session[:sort_option] || "date_created_desc"

    #session[:advsearchshow] = filters.any? { |filter| filter.present? }
    #session[:favesonly] is set through the favourties method
  end

  def handle_favourites
    if session[:favesonly] == true
      @workouts = current_user.workouts
    else
      @workouts = Workout.all
    end
  end

  def handle_search_name
    unless session[:search_name].blank?
      #turn "HIIT core" into ["%hiit%", "%core%"]
      search_name_array = session[:search_name].split.map {|val| "%#{val}%" }
      @workouts = @workouts.where("name ILIKE ANY ( array[?] )", search_name_array)
            .or( @workouts.where("brand ILIKE ANY ( array[?] )", search_name_array) )
            .or( @workouts.where("style ILIKE ANY ( array[?] )", search_name_array) )
            .or( @workouts.where("bodyfocus ILIKE ANY ( array[?] )", search_name_array) )

      #previous approach with SQLITE in development and no multi-word search
      #ILIKE is case-insensitive version of LIKE but postgreql only (not sqlite) hence need for lower instead
      #original approach does not recognise multi-word searches, so would fail to even find "HIIT" if "HIIT core" searched for
      # @workouts = @workouts.where("lower(name) LIKE ?", "%#{session[:search_name].downcase}%")
      #         .or(@workouts.where("lower(brand) LIKE ?", "%#{session[:search_name].downcase}%"))
      #         .or(@workouts.where("lower(style) LIKE ?", "%#{session[:search_name].downcase}%"))
      #         .or(@workouts.where("lower(bodyfocus) LIKE ?", "%#{session[:search_name].downcase}%"))
    end
  end

  def handle_advancedsearch
    @workouts = @workouts.where(style: session[:filter_style]) if session[:filter_style].present?
    @workouts = @workouts.where(intensity: session[:filter_intensity]) if session[:filter_intensity].present?
    @workouts = @workouts.where(bodyfocus: session[:filter_bodyfocus]) if session[:filter_bodyfocus].present?
  end

  def handle_not_loggedin
      message = "Please sign up for this feature."
      flash[:warning] = message
  end
end
