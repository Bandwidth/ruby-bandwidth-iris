module BandwidthIris
  AVAILABLE_NPA_NXX_PATH = 'availableNpaNxx'

  class AvailableNpaNxx
    extend ClientWrapper

    def self.list(client, query)
      client.make_request(:get, client.concat_account_path(AVAILABLE_NPA_NXX_PATH), query)[0][:available_npa_nxx_list][:available_npa_nxx]
    end
    wrap_client_arg :list

  end
end
