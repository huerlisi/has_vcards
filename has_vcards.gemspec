$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "has_vcards/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "has_vcards"
  s.version     = HasVcards::VERSION
  s.authors     = ["Simon Huerlimann (CyT)"]
  s.email       = ["simon.huerlimann@cyt.ch"]
  s.homepage    = "https://github.com/huerlisi/has_vcards"
  s.summary     = "vCard plugin for Rails"
  s.description = "vCard like contact and address models and helpers for Rails."
  s.license     = "MIT"

  s.files       = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files  = Dir["spec/**/*"]

  s.add_dependency "rails", "> 3.2.0"
  s.add_dependency "inherited_resources"
  s.add_dependency "simple_form"
  s.add_dependency "i18n_rails_helpers"
  s.add_dependency "haml"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "pg"
  s.add_development_dependency "mysql2"

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
end
