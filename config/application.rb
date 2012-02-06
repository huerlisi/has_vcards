require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require *Rails.groups(:assets) if defined?(Bundler)

module HasVcards
  class Application < Rails::Application
    # Configure generators values. Many other options are available, be sure to check the documentation.
    config.generators do |g|
      g.stylesheets false
      g.test_framework :rspec
      g.template_engine :haml
      g.fixture_replacement :factory_girl
    end
  end
end
