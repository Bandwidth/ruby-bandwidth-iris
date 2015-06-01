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

    def update(data)
      @client.make_request(:put, "#{@client.concat_account_path(ORDER_PATH)}/#{id}", {:order => data})[0]
    end

    def get_notes()
      list = @client.make_request(:get, "#{@client.concat_account_path(ORDER_PATH)}/#{id}/notes")[0][:note]
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
  end
end
