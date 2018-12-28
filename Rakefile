# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

task :rebuild do
  `gem build tails.gemspec`
  `gem install tails-#{Tails::VERSION}.gem`
end
