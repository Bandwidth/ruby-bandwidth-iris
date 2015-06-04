module BandwidthIris
  LIDB_PATH = 'lidbs'

  class Lidb
    extend ClientWrapper

    def self.list(client, query = nil)
      client.make_request(:get, client.concat_account_path(LIDB_PATH), query)[0]
    end
    wrap_client_arg :list

    def self.get(client, id)
      client.make_request(:get, "#{client.concat_account_path(LIDB_PATH)}/#{id}")[0]
    end
    wrap_client_arg :get

    def self.create(client, item)
      location = client.make_request(:post, client.concat_account_path(LIDB_PATH), {:lidb_order => item})[1][:location]
      id = Client.get_id_from_location_header(location)
      self.get(client, id)
    end
    wrap_client_arg :create
  end
end
