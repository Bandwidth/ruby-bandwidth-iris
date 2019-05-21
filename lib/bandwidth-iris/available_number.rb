module BandwidthIris
  AVAILABLE_NUMBER_PATH = 'availableNumbers'

  class AvailableNumber
    extend ClientWrapper

    def self.list(client, query)
      response = client.make_request(:get, client.concat_account_path(AVAILABLE_NUMBER_PATH), query)
      list = response[0] && response[0][:telephone_number_list] && response[0][:telephone_number_list][:telephone_number]
      list ||= response[0] && response[0][:telephone_number_detail_list] && response[0][:telephone_number_detail_list][:telephone_number_detail]
      return [] if !list
      if list.is_a?(Array) then list else [list] end
    end
    wrap_client_arg :list

  end
end
