# -*- mode: ruby -*-
# vim: ft=ruby tw=2 et

source 'https://rubygems.org'

gem 'jruby-openssl', :platforms => :jruby
gem 'rake'
gem 'yard'

group :development do
  gem 'pry'
  gem 'pry-rescue'

  platforms :ruby_19, :ruby_20, :ruby_21 do
    gem 'pry-stack_explorer'
    gem 'redcarpet'
  end
end


group :test do
  gem 'backports'
  gem 'coveralls', :require => false
  gem 'mime-types' , '~>1.25' , :platforms => [:jruby, :ruby_18]
  gem 'rspec' , '>= 2.14'
  gem 'simplecov' , :require => false
  gem 'webmock'
  gem 'yardstick'
end

platforms :rbx do
  gem 'racc'
  gem 'rubinius-coverage', '~>2.0'
  gem 'rubysl' , '~>2.0'
end

gemspec
