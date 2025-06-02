require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SampleApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    # Include the authenticity token in remote forms.
    config.action_view.embed_authenticity_token_in_remote_forms = true

    # DPS addition (seems to be the best way to add constants..
    # this is referenced in the problems and relationship_ps forms
    # no idea what the x is. Rails 5 not meant to be needed, but my experience is that it fails without
    # not needed for Wack and .yml file approach adopted for constants
    config.x.grades.options = %w[6a 6a+ 6b 6b+ 6c 6c+ 7a 7a+ 7b 7b+ 7c 7c+ 8a 8a+ 8b 8b+ 8c 8c+]    
  end
end
