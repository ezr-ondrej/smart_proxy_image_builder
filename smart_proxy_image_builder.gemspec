require File.expand_path('lib/smart_proxy_image_builder/version', __dir__)
require 'date'

Gem::Specification.new do |s|
  s.name        = 'smart_proxy_image_builder'
  s.version     = Proxy::ImageBuilder::VERSION
  s.date        = Date.today.to_s
  s.license     = 'GPL-3.0'
  s.authors     = ['Ondrej Ezr']
  s.email       = ['ezrik12@gmail.com']
  s.homepage    = 'https://github.com/theforeman/smart_proxy_image_builder'

  s.summary     = "A wrapper for Image Builder"
  s.description = "Allows building images from Foreman using Image Builder"

  s.files       = Dir['{config,lib,bundler.d}/**/*'] + ['README.md', 'LICENSE']
  s.test_files  = Dir['test/**/*']

  s.add_runtime_dependency('net_http_unix', '~> 0.2')
  s.add_runtime_dependency('multipart-post', '~> 2.1')

  s.add_development_dependency('rake')
  s.add_development_dependency('mocha')
  s.add_development_dependency('test-unit')
end
