module BandwidthIris
  ORDER_PATH = 'orders'

  class Order
    extend ClientWrapper
    include ApiItem

    def self.create(client, item)
      data = client.make_request(:post, client.concat_account_path(ORDER_PATH), {:order => item})[0][:order]
      Order.new(data, client)
    end
    wrap_client_arg :create

    def self.get(client, id)
      data = client.make_request(:get, "#{client.concat_account_path(ORDER_PATH)}/#{id}")[0][:order]
      Order.new(data, client)
    end
    wrap_client_arg :get

    def self.list(client, query = nil)
      list = client.make_request(:get, client.concat_account_path(ORDER_PATH), query)[0][:orders][:order]
      return [] if !list
      list = if list.is_a?(Array) then list else [list]  end
      list.map {|i| Order.new(i, client)}
    end
    wrap_client_arg :list

    #`get order` no longer returns an `id`, which means the subsequent `get_tns` call will fail
    #This is a workaround to provide the "get tns by order id" functionality
    def self.get_tns_by_order_id(client, id)
      client.make_request(:get, "#{client.concat_account_path(ORDER_PATH)}/#{id}/tns")[0]
    end
    wrap_client_arg :get_tns_by_order_id

    def update(data)
      @client.make_request(:put, "#{@client.concat_account_path(ORDER_PATH)}/#{id}", {:order => data})[0]
    end

    def get_notes()
      list = @client.make_request(:get, "#{@client.concat_account_path(ORDER_PATH)}/#{id}/notes")[0][:note]
      return [] if !list
      if list.is_a?(Array)
        list
      else
        [list]
      end
    end

    def add_notes(note)
      r = @client.make_request(:post, "#{@client.concat_account_path(ORDER_PATH)}/#{id}/notes", {:note => note})
      note_id = Client.get_id_from_location_header(r[1][:location])
      (get_notes().select {|n| n[:id].to_s == note_id }).first
    end

    def get_area_codes()
      list = @client.make_request(:get, "#{@client.concat_account_path(ORDER_PATH)}/#{id}/areaCodes")[0][:telephone_details_report]
      return [] if !list
      if list.is_a?(Array) then list else [list]  end
    end

    def get_npa_npx()
      list = @client.make_request(:get, "#{@client.concat_account_path(ORDER_PATH)}/#{id}/npaNxx")[0][:telephone_details_report]
      return [] if !list
      if list.is_a?(Array) then list else [list]  end
    end

    def get_totals()
      list = @client.make_request(:get, "#{@client.concat_account_path(ORDER_PATH)}/#{id}/totals")[0][:telephone_details_report]
      return [] if !list
      if list.is_a?(Array) then list else [list]  end
    end

    def get_tns()
      @client.make_request(:get, "#{@client.concat_account_path(ORDER_PATH)}/#{id}/tns")[0]
    end

    def get_history()
      list = @client.make_request(:get, "#{@client.concat_account_path(ORDER_PATH)}/#{id}/history")[0][:order_history]
      return [] if !list
      if list.is_a?(Array) then list else [list]  end
    end
  end
end
