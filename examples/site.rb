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


site = BandwidthIris::Site.create({
  :name => "Ruby Test Sitei1",
  :description => "A Site From Ruby SDK Examples",
  :address => {
    :house_number => "123",
    :street_name => "Anywhere St",
    :city => "Raleigh",
    :state_code =>"NC",
    :zip => "27609",
    :address_type => "Service"
  }
})

site.delete()
