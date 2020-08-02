class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        #redirect_back_or user
        redirect_back_or workouts_path
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
     flash.now[:danger] = 'Invalid email/password combination'
     if params[:pagecaller] == "welcome"
       @workouts = Workout.all.order("created_at desc")
       render 'static_pages/_welcome'
     else
      render 'new'
     end
    end

  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
