module BandwidthIris
  TN_OPTIONS_PATH = 'tnoptions'

  class TnOptions
    extend ClientWrapper
    include ApiItem

    def self.get_tn_option_orders(client, query = nil)
        response = client.make_request(:get, "#{client.concat_account_path(TN_OPTIONS_PATH)}", query)
        return response[0]
    end
    wrap_client_arg :get_tn_option_orders

    def self.create_tn_option_order(client, data)
        response = client.make_request(:post, "#{client.concat_account_path(TN_OPTIONS_PATH)}", {:tn_option_order => data})
        return response[0][:tn_option_order]
    end
    wrap_client_arg :create_tn_option_order

    def self.get_tn_option_order(client, order_id)
        response = client.make_request(:get, "#{client.concat_account_path(TN_OPTIONS_PATH)}/#{order_id}")
        return response[0]
    end
    wrap_client_arg :get_tn_option_order
  end
end
