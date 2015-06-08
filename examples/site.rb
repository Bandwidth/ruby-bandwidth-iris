require 'yaml'
require 'ruby-bandwidth-iris'

BandwidthIris::Client.global_options = YAML.load_file('config.yml')


site = BanwidthIris::Site.create({
  :name => "Ruby Test Site",
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
