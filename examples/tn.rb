require 'yaml'
require 'ruby-bandwidth-iris'

BandwidthIris::Client.global_options = YAML.load_file('config.yml')

puts  BanwidthIris::Tn.list({:npa => '818'})

puts  BanwidthIris::Tn.get('9195551212')
