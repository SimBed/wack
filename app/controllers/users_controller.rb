class UsersController < ApplicationController
  before_action :logged_in_as_real_user, only: [:edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :correct_user_or_admin, only: [:show]
  before_action :admin_user, only: [:index, :destroy]

  def index
    # @users = User.where(activated: true).paginate(page: params[:page])
    @pagy, @users = pagy(User.where(activated: true))
  end

  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated

    # @microposts = @user.microposts.paginate(page: params[:page])
    @pagy, @microposts = pagy(@user.microposts)    
    attempt_old_to_delete
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = 'Please check your email to activate your account.'
      redirect_to root_url
      # log_in @user
      # flash[:success] = "Welcome to the Sample App!"
      # redirect_to @user
      # equivalent to redirect_to user_url(@user) as Rail infers the user_url bit
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User deleted'
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def attempt_old_to_delete
    # @attempts = @user.attempts.paginate(page: params[:page])
    @pagy, @attempts = pagy(@user.attempts)    
    @attslw = @user.attempts.where('doa > ?', 1.week.ago)
  end

  # Before filters

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # Confirms the correct user or admin.
  def correct_user_or_admin
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user) || current_user&.admin?
  end
end
