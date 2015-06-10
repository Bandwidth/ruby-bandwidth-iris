module BandwidthIris
  COVERED_RATE_CENTER_PATH = 'coveredRateCenters'
  class CoveredRateCenter
    extend ClientWrapper
    include ApiItem

    def self.list(client, query = nil)
      list = client.make_request(:get, COVERED_RATE_CENTER_PATH, query)[0][:covered_rate_center]
      return [] if !list
      list = if list.is_a?(Array) then list else [list] end
      list.map do |i|
        CoveredRateCenter.new(i, client)
      end
    end
    wrap_client_arg :list
  end
end
