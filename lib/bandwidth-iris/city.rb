module BandwidthIris
  CITY_PATH = 'cities'

  class City
    extend ClientWrapper

    def self.list(client, query)
      list = client.make_request(:get, CITY_PATH, query)[0][:cities][:city]
      if list.is_a?(Array) then list else [list] end
    end
    wrap_client_arg :list

  end
end
