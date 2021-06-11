class AccountActivationsController < ApplicationController
  before_action :set_user, only: [:edit]
  def edit
    if @user && !@user.activated? && @user.authenticated?(:activation, params[:id])
      @user.activate
      log_in @user
      flash[:success] = 'Account activated!'
      redirect_to workouts_path
    else
      flash[:danger] = 'Invalid activation link'
      redirect_to root_url
    end
  end

  private

  def set_user
    @user = User.find_by(email: params[:email])
  end
end
