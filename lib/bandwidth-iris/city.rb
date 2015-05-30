module BandwidthIris
  CITY_PATH = 'cities'

  class City
    extend ClientWrapper

    def self.list(client, query)
      client.make_request(:get, CITY_PATH, query)[0][:cities][:city]
    end
    wrap_client_arg :list

  end
end
