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

number_to_check = '+12525130283' #TODO fill with valid number

host = '1.1.2.3'

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

  data = {
    :peer_name => "A New SIP Peer",
    :is_default_peer => true,
    :short_messaging_protocol => "SMPP",
    :site_id => site[:id],
    :voice_hosts =>
    {
        :host => {
          :host_name => host
        }
    },
    :sms_hosts =>
    {
        :host => {
          :host_name => host
        }
    },
    :termination_hosts =>
      {
        :termination_host => {
          :host_name => host,
          :port => 5060,
        }
      }

  }

  sip_peer = BandwidthIris::SipPeer.create(site[:id], data)

  res = BandwidthIris::LnpChecker.check(number_to_check)

  if res[:portable_numbers] && res[:portable_numbers][:tn] == number_to_check
    puts 'Your number is portable. Creating PortIn Order'
    port_in = BandwidthIris::PortIn.create(create_port_in_order(number_to_check, site, sip_peer))
    puts "Created order #{port_in[:id]}"
    port_in.create_file(File.open('./loa.pdf', 'r'), 'application/pdf')
  end
rescue BandwidthIris::Errors::GenericError => e
  puts e.message
end


def create_port_in_order(number, site, sip_peer)
   {
    :site_id => site[:id],
    :peer_id => sip_peer[:id],
    :billing_telephone_number => number,
    :subscriber => {
      :subscriber_type => "BUSINESS",
      :business_name => "Company",
      :service_address => {
        :house_number => "123",
        :street_name => "EZ Street",
        :city => "Raleigh",
        :state_code => "NC",
        :zip => "27615",
        :county => "Wake"
      }
    },
    :loa_authorizing_person => "Joe Blow",
    :list_of_phone_numbers => {
      :phoneNumber => number
    },
    :billingType => "PORTIN"
  }
end

