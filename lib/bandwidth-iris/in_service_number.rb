module BandwidthIris
  INSERVICE_NUMBER_PATH = 'inserviceNumbers'

  class InServiceNumber
    extend ClientWrapper

    def self.list(client, query = nil)
      list = client.make_request(:get, client.concat_account_path(INSERVICE_NUMBER_PATH), query)
      return list
    end
    wrap_client_arg :list

    def self.get(client, number)
      client.make_request(:get, "#{client.concat_account_path(INSERVICE_NUMBER_PATH)}/#{CGI.escape(number)}")[0]
    end
    wrap_client_arg :get

    def self.totals(client)
      client.make_request(:get, "#{client.concat_account_path(INSERVICE_NUMBER_PATH)}/totals")[0]
    end
    wrap_client_arg :totals
  end
end
