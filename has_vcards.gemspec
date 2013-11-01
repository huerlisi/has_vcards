# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'has_vcards/version'

Gem::Specification.new do |s|
  # Description
  s.name         = "has_vcards"
  s.version      = HasVcards::VERSION
  s.summary      = "vCard plugin for Rails"
  s.description  = "vCard like contact and address models and helpers for Rails."

  s.homepage     = "https://github.com/huerlisi/has_vcards"
  s.authors      = ["Simon Hürlimann (CyT)"]
  s.email        = "simon.huerlimann@cyt.ch"
  s.licenses     = ["MIT"]

  # Files
  s.extra_rdoc_files = [
    "MIT-LICENSE",
    "README.markdown"
  ]

  s.files        = `git ls-files app lib config db`.split("\n")

  s.platform     = Gem::Platform::RUBY

  # Dependencies
  s.add_dependency(%q<rails>, ["~> 3.0"])
  s.add_dependency(%q<inherited_resources>)
  s.add_dependency(%q<simple_form>)
  s.add_dependency(%q<i18n_rails_helpers>)
end
