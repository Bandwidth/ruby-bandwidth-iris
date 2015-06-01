module BandwidthIris
  SUBSCRIPTION_PATH = 'subscriptions'

  class Subscription
    extend ClientWrapper
    include ApiItem

    def self.list(client, query = nil)
      list = client.make_request(:get, client.concat_account_path(SUBSCRIPTION_PATH), query)[0][:subscriptions][:subscription]
      list = if list.is_a?(Array) then list else [list] end
      list.map do |i|
        i[:id] = i[:subscription_id]
        Subscription.new(i, client)
      end
    end
    wrap_client_arg :list

    def self.get(client, id)
      data  = client.make_request(:get, "#{client.concat_account_path(SUBSCRIPTION_PATH)}/#{id}")[0][:subscriptions][:subscription]
      data[:id] = data[:subscription_id]
      Subscription.new(data, client)
    end
    wrap_client_arg :get

    def self.create(client, item)
      location = client.make_request(:post, client.concat_account_path(SUBSCRIPTION_PATH), {:subscription => item})[1][:location]
      id = Client.get_id_from_location_header(location)
      self.get(client, id)
    end
    wrap_client_arg :create


    def update(data)
      @client.make_request(:put,"#{@client.concat_account_path(SUBSCRIPTION_PATH)}/#{id}", {:subscription => data})
    end

    def delete()
      @client.make_request(:delete,"#{@client.concat_account_path(SUBSCRIPTION_PATH)}/#{id}")
    end
  end
end
