require 'has_vcards'
require 'rails'
require 'inherited_resources'
require 'simple_form'
require 'i18n_rails_helpers'

module HasVcards
  class Engine < Rails::Engine
    initializer :after_initialize do
      ActionController::Base.helper HasVcardsHelper
      ActiveRecord::Base.extend(HasVcardsClassMethods)
      SwissMatch::Address.send :include, Vcard::DirectoryAddress if defined?(SwissMatch::Address)
    end
  end
end
