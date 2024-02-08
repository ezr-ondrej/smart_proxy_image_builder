require 'smart_proxy_plugin_template/api'

map "/plugin_template" do
  run Proxy::PluginTemplate::Api
end
