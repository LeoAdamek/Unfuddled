# -*- mode: ruby -*-
# vim: ft=ruby tw=2 et

require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
Rspec::Core::RakeTask.new(:spec)
task :test => :spec

require 'yard'
YARD::Rake::YardocTask.new

task :default => [:spec]


     
