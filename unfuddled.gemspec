# -*- mode: ruby -*-
# vim: ft=ruby tw=2 et

Gem::Specification.new do |s|
  s.name    = "unfuddled"
  s.version = '0.0.0'
  s.date    = '2014-01-13'
  s.summary = 'Unfuddle API Client Library'
  s.authors = ['Leo Adamek']
  s.email   = 'leo.adamek@mrzen.com'

  s.files   = %w(README.md unfuddled.gemspec)
  s.files  += Dir.glob('spec/**/*')
  s.files  += Dir.glob('lib/**/*.rb')

  s.license = 'MIT'

  s.add_dependency 'addressable'
  s.add_dependency 'memoizable'
  s.add_dependency 'faraday'
  s.add_dependency 'faraday_middleware'
  
  s.add_development_dependency 'bundler'

  s.require_paths = %w[lib]
end
