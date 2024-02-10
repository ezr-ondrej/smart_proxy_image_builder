require 'net/http/post/multipart'

module Proxy
  module ImageBuilder
    class ForesterAPI
      def initialize(logger, url)
        @logger = logger
        uri = URI.parse(url)
        @client = Net::HTTP.new(uri.host, uri.port)
      end

      def push_image(name, file)
        @logger.debug "Requesting upload path for image #{name}"
        req = Net::HTTP::Post.new("/rpc/ImageService/Create", 'Content-Type' => 'application/json')
        req.body = { image: { name: name } }.to_json
        res = @client.request(req)
        @logger.debug "Response: #{res.body}"
        fileResp = JSON.parse(res.body)

        # TODO: handle errors

        req = Net::HTTP::Post::Multipart.new fileResp['uploadPath'],
          "file" => UploadIO.new(file, "application/tar", File.basename(file))

        res = @client.request(req)
        @logger.debug "Response: #{res.body}"
        res
      end

      def list_systems
        @logger.debug "Requesting list of systems"
        req = Net::HTTP::Post.new("/rpc/SystemService/List", 'Content-Type' => 'application/json')
        req.body = { limit: 200, offset: 0 }.to_json
        res = @client.request(req)
        @logger.debug "Response: #{res.body}"
        res
      end

      def deploy(system_name_pattern, image_name_pattern)
        @logger.debug "Requesting deployment of image #{image_name_pattern} to system #{system_name_pattern}"
        req = Net::HTTP::Post.new("/rpc/SystemService/Deploy", 'Content-Type' => 'application/json')
        req.body = { systemPattern: system_name_pattern, imagePattern: image_name_pattern, snippets: [], comment: "Deployed by Foreman", duration: (Time.now + 3 * 60 * 60).utc.iso8601 }.to_json
        res = @client.request(req)
        @logger.debug "Response: #{res.body}"
        res
      end
    end
  end
end