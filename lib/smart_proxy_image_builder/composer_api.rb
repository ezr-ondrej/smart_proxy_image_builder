require 'net_http_unix'
require 'tempfile'

module Proxy
  module ImageBuilder
    class ComposerAPI
      def initialize(logger, socket_path)
        @logger = logger
        @client = NetX::HTTPUnix.new("unix://#{socket_path}")
      end

      def list_blueprints
        @logger.debug "Listing blueprints"
        req = Net::HTTP::Get.new("/api/v1/blueprints/list")
        response = @client.request(req)
        blueprint_names = JSON.parse(response.body)['blueprints']

        req = Net::HTTP::Get.new("/api/v1/blueprints/info/#{URI::encode blueprint_names.join(',')}")
        response = @client.request(req)

        @logger.debug "Response: #{response.body}"
        response
      end

      def push_blueprint(blueprint_data)
        @logger.debug "Pushing new blueprint"
        @logger.debug "Data: #{blueprint_data}"

        req = Net::HTTP::Post.new("/api/v1/blueprints/new", 'Content-Type' => 'text/x-toml')
        req.body = blueprint_data
        response = @client.request(req)
        @logger.debug "Response: #{response.body}"
        response
      end

      def build_image(blueprint_name, image_type)
        @logger.debug "Building new #{image_type} image for blueprint #{blueprint_name}"

        req = Net::HTTP::Post.new("/api/v1/compose", 'Content-Type' => 'application/json')
        req.body = { blueprint_name: blueprint_name, compose_type: image_type, branch: 'master' }.to_json
        response = @client.request(req)
        @logger.debug "Response: #{response.body}"
        response
      end

      def list_images
        @logger.debug "Listing images"
        req = Net::HTTP::Get.new("/api/v1/compose/finished")
        response = @client.request(req)
        @logger.debug "Response: #{response.body}"
        response
      end

      def download_image(image_id, file)
        @logger.debug "Downloading image #{image_id} to #{file.path}"
        @client.request_get("/api/v1/compose/results/#{image_id}") do |resp|
          resp.read_body do |segment|
            file.write(segment)
          end
        end
        true
      end
    end
  end
end