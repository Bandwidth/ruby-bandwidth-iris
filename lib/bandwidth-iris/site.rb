module BandwidthIris
  SITE_PATH = 'sites'

  class Site
    extend ClientWrapper
    include ApiItem

    def self.list(client, query = nil)
      list = client.make_request(:get, client.concat_account_path(SITE_PATH), query)[0][:sites][:site]
      list = if list.is_a?(Array) then list else [list] end
      list.map do |i|
        Site.new(i, client)
      end
    end
    wrap_client_arg :list

    def self.get(client, id)
      data  = client.make_request(:get, "#{client.concat_account_path(SITE_PATH)}/#{id}")[0]
      Site.new(data[:site], client)
    end
    wrap_client_arg :get

    def self.create(client, item)
      location = client.make_request(:post, client.concat_account_path(SITE_PATH), {:site => item})[1][:location]
      id = Client.get_id_from_location_header(location)
      self.get(client, id)
    end
    wrap_client_arg :create


    def update(data)
      @client.make_request(:put,"#{@client.concat_account_path(SITE_PATH)}/#{id}", {:site => data})
    end

    def delete()
      @client.make_request(:delete,"#{@client.concat_account_path(SITE_PATH)}/#{id}")
    end

    def get_sip_peer(peer_id)
      item = @client.make_request(:get, "#{@client.concat_account_path(SITE_PATH)}/#{id}/sippeers/#{peer_id}")[0][:sip_peer]
      item[:id] = item[:peer_id]
      item
    end

    def get_sip_peers()
      list = @client.make_request(:get, "#{@client.concat_account_path(SITE_PATH)}/#{id}/sippeers")[0][:sip_peers][:sip_peer]
      return [] if !list
      list = if list.is_a?(Array) then list else [list] end
      list.each {|i| i[:id] = i[:peer_id]}
      list
    end

    def create_sip_peer(item)
       location = @client.make_request(:post, "#{@client.concat_account_path(SITE_PATH)}/#{id}/sippeers", {:sip_peer => item})[1][:location]
       id = Client.get_id_from_location_header(location)
       get_sip_peer(id)
    end

    def get_portins()
      list = @client.make_request(:get, "#{@client.concat_account_path(SITE_PATH)}/#{id}/portins")[0]
      # TODO need additional documentaion
      list
    end

    def get_totaltns()
      list = @client.make_request(:get, "#{@client.concat_account_path(SITE_PATH)}/#{id}/totaltns")[0]
      # TODO need additional documentaion
      list
    end

    def get_orders()
      list = @client.make_request(:get, "#{@client.concat_account_path(SITE_PATH)}/#{id}/orders")[0]
      # TODO need additional documentaion
      list
    end

    def get_inservice_numbers()
      list = @client.make_request(:get, "#{@client.concat_account_path(SITE_PATH)}/#{id}/inserviceNumbers")[0]
      # TODO need additional documentaion
      list
    end
  end
end
