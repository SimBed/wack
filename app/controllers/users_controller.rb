class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
     flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
      #equivalent to redirect_to user_url(@user) as Rail infers the user_url bit
    else
      render 'new'
    end
  end
  
 private
  
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                     :password_confirmation)
    end
end