module BandwidthIris
  class Account
    extend ClientWrapper

    def self.get(client)
      client.make_request(:get, client.concat_account_path(nil))[0][:account]
    end
    wrap_client_arg :get
  end
end
