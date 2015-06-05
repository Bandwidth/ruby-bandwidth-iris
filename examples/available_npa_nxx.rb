require 'yaml'
require 'ruby-bandwidth-iris'

BandwidthIris::Client.global_options = YAML.load_file('config.yml')


puts BandwidthIris::AvailableNpaNxx.get({:area_code => "919", quantity => 3})

