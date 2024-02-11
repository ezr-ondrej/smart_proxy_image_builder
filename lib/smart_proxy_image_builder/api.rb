require 'smart_proxy_image_builder/composer_api'
require 'smart_proxy_image_builder/forester_api'

module Proxy
  module ImageBuilder
    class Api < ::Sinatra::Base
      helpers ::Proxy::Helpers

      # Require authentication
      # authorize_with_trusted_hosts
      # authorize_with_ssl_client

      get '/blueprints' do
        response = ImageBuilder::ComposerAPI.new(logger, ImageBuilder::Plugin.settings.composer_socket).list_blueprints
        
        response.body
      end

      post '/blueprints' do
        request.body.rewind
        data = request.body.read

        response = ImageBuilder::ComposerAPI.new(logger, ImageBuilder::Plugin.settings.composer_socket).push_blueprint(data)
        
        response.body
      end

      post '/blueprints/:name/build' do |blueprint_name|
        response = ImageBuilder::ComposerAPI.new(logger, ImageBuilder::Plugin.settings.composer_socket).build_image(blueprint_name, 'image-installer')
        
        response.body
      end

      get '/images' do
        response = ImageBuilder::ComposerAPI.new(logger, ImageBuilder::Plugin.settings.composer_socket).list_images
        
        response.body
      end

      post '/images/:id/sync' do |image_id|
        file = Tempfile.new("#{image_id}.tar")
        downloaded = ImageBuilder::ComposerAPI.new(logger, ImageBuilder::Plugin.settings.composer_socket).download_image(image_id, file)

        return 404 unless downloaded

        file.rewind
        response = ImageBuilder::ForesterAPI.new(logger, ImageBuilder::Plugin.settings.forester_url).push_image(image_id, file)

        file.close
        file.unlink
        response.body
      end

      get '/systems' do
        response = ImageBuilder::ForesterAPI.new(logger, ImageBuilder::Plugin.settings.forester_url).list_systems

        response.body
      end

      post '/systems' do
        response = ImageBuilder::ForesterAPI.new(logger, ImageBuilder::Plugin.settings.forester_url).deploy(params[:system_pattern], params[:image_pattern])

        response.body
      end
    end
  end
end
