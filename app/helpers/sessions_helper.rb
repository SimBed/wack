module SessionsHelper

  def clear_session(*args)
    args.each do |session_key|
      session[session_key] = nil
    end
  end

  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

 # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end

  # Returns true if the given user is the current user or admin.
   def current_user_or_admin?(user)
     (user == current_user) or (current_user.admin?)
   end

  # Returns the user corresponding to the remember token cookie.
  def current_user
    if (user_id = session[:user_id])
      # helpful to think of a ||= b as a || a = b (because || returns the first true thing it comes to)
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    else
      # when noone is logged in, have demo user logged in
      @current_user = User.find_by(id: 22)
    end
  end


  #more understandable code in (without the 'assignment')
  #if session[:user_id]
  #@current_user ||= User.find_by(id: session[:user_id])
#elsif cookies.signed[:user_id]
 #user = User.find_by(id: cookies.signed[:user_id])
  #if user && user.authenticated?(cookies[:remember_token])
    #log_in user
   # @current_user = user
  #end
#end

      #@current_user ||= User.find_by(id: session[:user_id])
      # complicated version of

      #@current_user = @current_user || User.find_by(id: session[:user_id])
      #itself a slightly complicated version of

      #if @current_user.nil?
      #  @current_user = User.find_by(id: session[:user_id])
      #else
      #  @current_user
      #end


  # Returns true if the user is logged in, false otherwise.
  # the demo user is now logged in as default, so this should now always be true
  def logged_in?
    !current_user.nil?
  end

 # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
    clear_session(:filter_style, :filter_intensity, :filter_bodyfocus, :search_name, :favesonly, :sort_option)
  end

  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
