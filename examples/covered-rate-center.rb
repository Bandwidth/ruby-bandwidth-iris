require 'yaml'
require 'ruby-bandwidth-iris'

BandwidthIris::Client.global_options = YAML.load_file('config.yml')


puts BandwidthIris::CoveredRateCenter.list({:zip => '27609'})

