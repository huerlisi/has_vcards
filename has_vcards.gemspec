# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'has_vcards/version'

Gem::Specification.new do |s|
  s.name         = "has_vcards"
  s.version      = HasVcards::VERSION
  s.authors      = ["Simon Hürlimann (CyT)"]
  s.email        = "simon.huerlimann@cyt.ch"
  s.homepage     = "https://github.com/huerlisi/has_vcards"
  s.summary      = "vCard plugin for Rails"
  s.description  = "vCard like contact and address models and helpers for Rails."

  s.files        = `git ls-files app lib config`.split("\n")
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'

  s.extra_rdoc_files = ["README.markdown"]
end
