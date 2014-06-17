require 'has_vcards'
require 'rails'
require 'inherited_resources'
require 'simple_form'
require 'i18n_rails_helpers'

module HasVcards
  class Engine < Rails::Engine
    isolate_namespace HasVcards

    config.generators do |g|
      g.stylesheets false

      g.test_framework :rspec
      g.fixture_replacement :factory_girl
    end

    initializer :after_initialize do
      ActionController::Base.helper HasVcards::ApplicationHelper
      ActiveRecord::Base.extend HasVcards::ClassMethods
      SwissMatch::Address.send :include, Vcard::DirectoryAddress if defined?(SwissMatch::Address)
    end
  end
end
