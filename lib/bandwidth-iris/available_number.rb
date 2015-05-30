module BandwidthIris
  AVAILABLE_NUMBER_PATH = 'availableNumbers'

  class AvailableNumber
    extend ClientWrapper

    def self.list(client, query)
      client.make_request(:get, client.concat_account_path(AVAILABLE_NUMBER_PATH), query)[0][:telephone_number_detail_list][:telephone_number_detail]
    end
    wrap_client_arg :list

  end
end
