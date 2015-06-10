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

host = '10.20.30.41'


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


sip_peer.delete(site[:id])
