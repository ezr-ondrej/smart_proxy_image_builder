require File.expand_path('lib/smart_proxy_plugin_template/version', __dir__)
require 'date'

Gem::Specification.new do |s|
  s.name        = 'smart_proxy_plugin_template'
  s.version     = Proxy::PluginTemplate::VERSION
  s.date        = Date.today.to_s
  s.license     = 'GPL-3.0'
  s.authors     = ['TODO: Your name']
  s.email       = ['TODO: Your email']
  s.homepage    = 'https://github.com/theforeman/smart_proxy_plugin_template'

  s.summary     = "TODO A Plugin for Foreman's smart proxy"
  s.description = "TODO A longer description of the plugin for Foreman's smart proxy"

  s.files       = Dir['{config,lib,bundler.d}/**/*'] + ['README.md', 'LICENSE']
  s.test_files  = Dir['test/**/*']

  s.add_development_dependency('rake')
  s.add_development_dependency('mocha')
  s.add_development_dependency('test-unit')
end
