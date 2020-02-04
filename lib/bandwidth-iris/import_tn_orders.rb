module BandwidthIris
  IMPORT_TN_ORDERS_PATH = "importTnOrders"

  class ImportTnOrders
    extend ClientWrapper
    include ApiItem

    def self.get_import_tn_orders(client, query)
      data = client.make_request(:get, client.concat_account_path(IMPORT_TN_ORDERS_PATH), query)
      return data
    end
    wrap_client_arg :get_import_tn_orders

    def self.get_import_tn_order(client, order_id)
      data = client.make_request(:get, client.concat_account_path("#{IMPORT_TN_ORDERS_PATH}/#{order_id}"))
      return data
    end
    wrap_client_arg :get_import_tn_order

    def self.get_import_tn_order_history(client, order_id)
      data = client.make_request(:get, client.concat_account_path("#{IMPORT_TN_ORDERS_PATH}/#{order_id}/history"))
      return data
    end
    wrap_client_arg :get_import_tn_order_history

    def self.create_import_tn_order(client, import_tn_order)
      data = client.make_request(:post, client.concat_account_path("#{IMPORT_TN_ORDERS_PATH}"), {:import_tn_order => import_tn_order})
      return data
    end
    wrap_client_arg :create_import_tn_order
  end
end
