require 'has_vcards/engine'

# Base module
#
# This defines the namespace and adds autoload definitions.
module HasVcards
  extend ActiveSupport::Autoload

  autoload :ClassMethods
end
