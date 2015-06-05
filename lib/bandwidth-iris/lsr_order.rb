module BandwidthIris
  LSR_ORDER_PATH = 'lsrorders'

  class LsrOrder
    extend ClientWrapper
    include ApiItem

    def self.create(client, item)
      item['_sPIDXmlElement'] = 'sPID'
      location = client.make_request(:post, client.concat_account_path(LSR_ORDER_PATH), {:lsr_order => item})[1][:location]
      id = Client.get_id_from_location_header(location)
      self.get(client, id)
    end
    wrap_client_arg :create

    def self.list(client, query = nil)
      list = client.make_request(:get, client.concat_account_path(LSR_ORDER_PATH), query)[0][:lsr_order_summary]
      list = if list.is_a?(Array) then list else [list] end
      list.map do |i|
        i[:id] = i[:order_id]
        LsrOrder.new(i, client)
      end
    end
    wrap_client_arg :list

    def self.get(client, id)
      data  = client.make_request(:get, "#{client.concat_account_path(LSR_ORDER_PATH)}/#{id}")[0]
      data[:id] = data[:order_id]
      LsrOrder.new(data, client)
    end
    wrap_client_arg :get

    def update(data)
      @client.make_request(:put,"#{@client.concat_account_path(LSR_ORDER_PATH)}/#{id}", {:lsr_order => data})
    end

    def get_notes()
      list = @client.make_request(:get, "#{@client.concat_account_path(LSR_ORDER_PATH)}/#{id}/notes")[0][:note]
      if list.is_a?(Array)
        list
      else
        [list]
      end
    end

    def add_notes(note)
      r = @client.make_request(:post, "#{@client.concat_account_path(LSR_ORDER_PATH)}/#{id}/notes", {:note => note})
      note_id = Client.get_id_from_location_header(r[1][:location])
      (get_notes().select {|n| n[:id].to_s == note_id }).first
    end


    def get_history()
      @client.make_request(:get,"#{@client.concat_account_path(LSR_ORDER_PATH)}/#{id}/history")[0][:order_history]
    end
  end
end
