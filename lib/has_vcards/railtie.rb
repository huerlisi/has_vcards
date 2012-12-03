require 'has_vcards'
require 'rails'

module HasVcards
  class Railtie < Rails::Engine
    engine_name "has_vcards"

    initializer :after_initialize do
      ActionController::Base.helper HasVcardsHelper

      ActiveRecord::Base.extend(HasVcardsClassMethods)

      SwissMatch::Address.send :include, Vcard::DirectoryAddress if defined?(SwissMatch::Address)
    end
  end
end
