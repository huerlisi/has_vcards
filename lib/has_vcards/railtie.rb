require 'has_vcards'
require 'rails'

module HasVcards
  class Railtie < Rails::Engine
    engine_name "has_vcards"

    initializer :after_initialize do
      ActionController::Base.helper HasVcardsHelper

      ActiveRecord::Base.extend(HasVcardsClassMethods)
    end
  end
end
