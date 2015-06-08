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

order =  BandwidthIris::Orders.create({
  :name =>"A Test Order",
  :site_id => site.id,
  :existing_telephone_number_order_type => {
    :telephone_number_list =>[
      {
        :telephone_number => '+12524101959'
      }
    ]
  }
})

puts order.to_data

order = BandwidthIris::Orders.get(order.id)

puts order.to_data

order.delete()
site.delete()

