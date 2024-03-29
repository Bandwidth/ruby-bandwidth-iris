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

begin
  BandwidthIris::CoveredRateCenter.list({:zip => '27609', :page=>1, :size=>100}).each do |c|
    puts c.to_data
  end
rescue BandwidthIris::Errors::GenericError => e
  puts e.message
end

