require 'yaml'
require 'ruby-bandwidth-iris'

BandwidthIris::Client.global_options = YAML.load_file('config.yml')

host = '1.1.1.1'


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

data = {
  :peer_name => "A New SIP Peer",
  :is_default_peer => false,
  :short_messaging_protocol => "SMPP",
  :site_id => site[:id],
  :voice_hosts => [
    {
      :host => {
        :host_name => host
      }
    }
  ],
  :sms_hosts => [
    {
      :host => {
        :host_name => host
      }
    }
  ],
  :termination_hosts => [
    {
      :termination_host => {
        :host_name => host,
        :port => 5060,
      }
    }
  ]
}

sip_peer = BandwidthIris::SipPeer.create(data)


sip_peer.delete()
site.delete()
