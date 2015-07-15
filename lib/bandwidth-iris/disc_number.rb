module BandwidthIris
  DISC_NUMBER_PATH = 'discnumbers'

  class DiscNumber
    extend ClientWrapper
    include ApiItem

    def self.list(client)
      client.make_request(:get, client.concat_account_path(DISC_NUMBER_PATH))[0][:telephone_numbers]
    end
    wrap_client_arg :list


    def self.totals(client)
      client.make_request(:get, "#{client.concat_account_path(DISC_NUMBER_PATH)}/totals")[0]
    end
    wrap_client_arg :totals
  end
end
