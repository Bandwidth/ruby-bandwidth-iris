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

number = '9195551212' #exisitng number for order

begin
  site = BandwidthIris::Site.create({
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

  order =  BandwidthIris::Order.create({
    :name =>"A Test Order",
    :site_id => site.id,
    :existing_telephone_number_order_type => {
      :telephone_number_list =>
        {
          :telephone_number => [number]
        }

    }
  })

  puts order.to_data

  order = BandwidthIris::Order.get(order.id)
rescue BandwidthIris::Errors::GenericError => e
  puts e.message
end


puts order.to_data

order.delete()
site.delete()

