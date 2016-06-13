source 'https://rubygems.org'

# Declare your gem's dependencies in has_vcards.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

gem 'rails', '~> 4.2'

group :tools do
  # Debugger
  gem 'pry-rails'
  # Disabled debuggers as there seems no proper way to get this working.
  # gem 'pry-byebug', :platform => [:mri_20, :mri_21, :mri_22]
  # gem 'pry-debugger', :platform => [:mri_19]

  # QA
  gem 'rubocop'
  gem 'rubocop-rspec'
end
