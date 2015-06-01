module BandwidthIris
  RATE_CENTER_PATH = 'rateCenters'

  class RateCenter
    extend ClientWrapper

    def self.list(client)
      list = client.make_request(:get, RATE_CENTER_PATH)[0][:rate_centers][:rate_center]
      if list.is_a?(Array)
        list
      else
        [list]
      end
    end
    wrap_client_arg :list

  end
end
