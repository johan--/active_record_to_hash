require_relative 'boot'

# Pick the frameworks you want:
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'action_mailer/railtie'
require 'active_job/railtie'
require 'action_cable/engine'
# require "rails/test_unit/railtie"
require 'sprockets/railtie'

Bundler.require(*Rails.groups)
require 'active_record_to_hash'

module Dummy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.generators do |g|
      g.test_framework :rspec,
        fixtures: false,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: true,
        request_specs: false
      g.fixture_replacement :factory_bot, dir: Rails.root.join('spec', 'factories')
    end

    # http://davidvg.com/2010/04/06/missing-foreign-key-constraints-in-rails-test-database
    # This setting is necessary for `spec/lib/dynamic_scaffold/controllers/controls/country_controller_spec.rb#Delete`
    config.active_record.schema_format = :sql
  end
end
