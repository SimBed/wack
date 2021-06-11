ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Returns true if a test user is logged in.
    def is_logged_in?
      !session[:user_id].nil?
    end

    # Log in as a particular user.
    # Our method for logging a user in depends on the type of test.
    # Inside controller tests, we can manipulate the session directly.
    def log_in_as(user)
      session[:user_id] = user.id
    end

    def dailypickfortesting
      require 'date'
      srand Time.zone.today.to_time.to_i
      rand(Workout.count) - 1
    end
  end
end

module ActionDispatch
  class IntegrationTest
    # Log in as a particular user.
    # Inside integration tests, we cant manipulate session
    # directly but we can post to the sessions path
    def log_in_as(user, password: 'password', remember_me: '1')
      post login_path, params: { session: { email: user.email,
                                            password: password,
                                            remember_me: remember_me } }
    end
  end
end
