require 'smart_proxy_image_builder/api'

map "/image_builder" do
  run Proxy::ImageBuilder::Api
end
