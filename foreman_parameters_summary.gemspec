require File.expand_path('../lib/foreman_parameters_summary/version', __FILE__)
require "active_support/all"
require "active_support/time"
require 'date'

Gem::Specification.new do |s|
  s.name        = 'foreman_parameters_summary'
  s.version     = ForemanParametersSummary::VERSION
  s.date        = Date.today.to_s
  s.license     = 'GPL-3.0'
  s.authors     = ['David Barbion']
  s.email       = ['davidb@230ruedubac.fr']
  s.homepage    = 'https://github.com/david-barbion/foreman_parameters_summary'
  s.summary     = "Foreman plug-in that show parameter's values"
  # also update locale/gemspec.rb
  s.description = 'View all overriden values of a specific parameter in a single view'

  s.files = Dir['{app,config,db,lib,locale}/**/*'] + ['LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rdoc'
end
