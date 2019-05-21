lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'yaml'
require 'ruby-bandwidth-iris'
config = YAML.load_file('config.yml')

BandwidthIris::Client.global_options = {
  :api_endpoint => config['api_endpoint'],
  :user_name => config['user_name'],
  :password => config['password'],
  :account_id => config['account_id']
}

puts BandwidthIris::AvailableNumber.list({:state => "NC", :quantity => 3, :enable_t_n_detail => true})
