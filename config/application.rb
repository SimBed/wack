require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SampleApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Include the authenticity token in remote forms.
    config.action_view.embed_authenticity_token_in_remote_forms = true

    # DPS addition (seems to be the best way to add constants..
    # this is referenced in the problems and relationship_ps forms
    # no idea what the x is. Rails 5 not meant to be needed, but my experience is that it fails without
    # not needed for Wack and .yml file approach adopted for constants
    config.x.grades.options = %w[6a 6a+ 6b 6b+ 6c 6c+ 7a 7a+ 7b 7b+ 7c 7c+ 8a 8a+ 8b 8b+ 8c 8c+]
  end
end
