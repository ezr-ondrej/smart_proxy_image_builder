require_relative 'version'

module Proxy
  module ImageBuilder
    class Plugin < ::Proxy::Plugin
      plugin :image_builder, ::Proxy::ImageBuilder::VERSION
      rackup_path File.expand_path('http_config.ru', __dir__)

      # Settings listed under default_settings are required.
      # An exception will be raised if they are initialized with nil values.
      # Settings not listed under default_settings are considered optional and by default have nil value.
      default_settings composer_socket: 'composer_socket' #, required_path: '/must/exist'

      # Verifies that a file exists and is readable.
      # Uninitialized optional settings will not trigger validation errors.
      # validate_readable :composer_socket
    end
  end
end
