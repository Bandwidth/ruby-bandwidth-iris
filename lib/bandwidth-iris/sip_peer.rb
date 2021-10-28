module BandwidthIris
  SIPPEER_PATH = 'sippeers'

  class SipPeer
    extend ClientWrapper
    include ApiItem

    def self.list(client, site_id)
      Site.new({:id => site_id}, client).get_sip_peers()
    end
    wrap_client_arg :list

    def self.get(client, site_id, id)
      Site.new({:id => site_id}, client).get_sip_peer(id)
    end
    wrap_client_arg :get

    def self.create(client, site_id, item)
      Site.new({:id => site_id}, client).create_sip_peer(item)
    end
    wrap_client_arg :create

    def delete()
      @client.make_request(:delete,"#{@client.concat_account_path(SITE_PATH)}/#{site_id}/#{SIPPEER_PATH}/#{id}")
    end


    def get_tns(number = nil)
      r = @client.make_request(:get,"#{@client.concat_account_path(SITE_PATH)}/#{site_id}/#{SIPPEER_PATH}/#{id}/tns#{if number then '/' + CGI.escape(number) else '' end}")[0]
      if number
        r[:sip_peer_telephone_number]
      else
        list = r[:sip_peer_telephone_numbers][:sip_peer_telephone_number]
        return [] if !list
        if list.is_a?(Array) then list else [list] end
      end
    end

    def update_tns(number, data)
      @client.make_request(:put,"#{@client.concat_account_path(SITE_PATH)}/#{site_id}/#{SIPPEER_PATH}/#{id}/tns/#{CGI.escape(number)}", {:sip_peer_telephone_number => data})[0]
    end

    def move_tns(numbers)
      @client.make_request(:post,"#{@client.concat_account_path(SITE_PATH)}/#{site_id}/#{SIPPEER_PATH}/#{id}/movetns", {:sip_peer_telephone_numbers => {:full_number => numbers}})[0]
    end
  end
end
