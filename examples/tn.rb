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

list = BandwidthIris::Tn.list({:npa => '818', :page => 1, :size => 100}).each do |n|
  puts n.to_data
end

puts BandwidthIris::Tn.get(list[0][:full_number]).to_data
