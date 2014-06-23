require 'has_vcards'
require 'rails'
require 'inherited_resources'
require 'simple_form'
require 'i18n_rails_helpers'

module HasVcards
  # The Engine
  #
  # Integrates the has_vcards gem with Rails. It adds the view and class helpers.
  #
  # We use an isolated_namespace, that means all the classes, views, helpers etc
  # are only available in the HasVcards:: namespace.
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
