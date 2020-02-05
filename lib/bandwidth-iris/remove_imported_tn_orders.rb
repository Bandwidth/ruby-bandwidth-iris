module BandwidthIris
  REMOVE_IMPORTED_TN_ORDERS_PATH = "removeImportedTnOrders"

  class RemoveImportedTnOrders
    extend ClientWrapper
    include ApiItem
    
    def self.get_remove_imported_tn_orders(client, query = nil)
      data = client.make_request(:get, client.concat_account_path(REMOVE_IMPORTED_TN_ORDERS_PATH), query)
      return data
    end
    wrap_client_arg :get_remove_imported_tn_orders

    def self.get_remove_imported_tn_order(client, order_id)
      data = client.make_request(:get, client.concat_account_path("#{REMOVE_IMPORTED_TN_ORDERS_PATH}/#{order_id}"))
      return data
    end
    wrap_client_arg :get_remove_imported_tn_order

    def self.get_remove_imported_tn_order_history(client, order_id)
      data = client.make_request(:get, client.concat_account_path("#{REMOVE_IMPORTED_TN_ORDERS_PATH}/#{order_id}/history"))
      return data
    end
    wrap_client_arg :get_remove_imported_tn_order_history

    def self.create_remove_imported_tn_order(client, remove_imported_tn_order)
      data = client.make_request(:post, client.concat_account_path("#{REMOVE_IMPORTED_TN_ORDERS_PATH}"), {:remove_imported_tn_order => remove_imported_tn_order})
      return data
    end
    wrap_client_arg :create_remove_imported_tn_order
