module BandwidthIris
  DLDA_PATH = 'dldas'

  class Dlda
    extend ClientWrapper
    include ApiItem

    def self.list(client, query = nil)
      list = client.make_request(:get, client.concat_account_path(DLDA_PATH), query)[0][:list_order_id_user_id_date][:order_id_user_id_date]
      return [] if !list
      list = if list.is_a?(Array) then list else [list] end
      list.map do |i|
        i[:id] = i[:order_id]
        Dlda.new(i, client)
      end
    end
    wrap_client_arg :list

    def self.get(client, id)
      data  = client.make_request(:get, "#{client.concat_account_path(DLDA_PATH)}/#{id}")[0]
      data[:id] = data[:dlda_order][:order_id]
      Dlda.new(data, client)
    end
    wrap_client_arg :get

    def self.create(client, item)
      location = client.make_request(:post, client.concat_account_path(DLDA_PATH), {:dlda_order => item})[1][:location]
      id = Client.get_id_from_location_header(location)
      self.get(client, id)
    end
    wrap_client_arg :create


    def get_history()
      @client.make_request(:get,"#{@client.concat_account_path(DLDA_PATH)}/#{id}/history")[0][:order_history]
    end

  end
end
