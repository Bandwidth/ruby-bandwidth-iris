module BandwidthIris
  AVAILABLE_NUMBER_PATH = 'availableNumbers'

  class AvailableNumber
    extend ClientWrapper

    def self.list(client, query)
      list = client.make_request(:get, client.concat_account_path(AVAILABLE_NUMBER_PATH), query)[0][:telephone_number_list][:telephone_number]
      return [] if !list
      if list.is_a?(Array) then list else [list] end
    end
    wrap_client_arg :list

  end
end
