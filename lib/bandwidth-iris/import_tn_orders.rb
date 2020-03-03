module BandwidthIris
  IMPORT_TN_ORDERS_PATH = "importtnorders"

  class ImportTnOrders
    extend ClientWrapper
    include ApiItem

    def self.get_import_tn_orders(client, query = nil)
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

    def self.get_loa_files(client, order_id)
      data = client.make_request(:get, client.concat_account_path("#{IMPORT_TN_ORDERS_PATH}/#{order_id}/#{LOAS_PATH}"))
      return data
    end
    wrap_client_arg :get_loa_files

    def self.upload_loa_file(client, order_id, file_contents, mime_type)
      client.make_request_file_upload(:post, client.concat_account_path("#{IMPORT_TN_ORDERS_PATH}/#{order_id}/#{LOAS_PATH}"), file_contents, mime_type)
    end
    wrap_client_arg :upload_loa_file

    def self.download_loa_file(client, order_id, file_id)
      data = client.make_request_file_download(:get, client.concat_account_path("#{IMPORT_TN_ORDERS_PATH}/#{order_id}/#{LOAS_PATH}/#{file_id}"))
      return data
    end
    wrap_client_arg :download_loa_file

    def self.replace_loa_file(client, order_id, file_id, file_contents, mime_type)
      data = client.make_request_file_upload(:put, client.concat_account_path("#{IMPORT_TN_ORDERS_PATH}/#{order_id}/#{LOAS_PATH}/#{file_id}"), file_contents, mime_type)
    end
    wrap_client_arg :replace_loa_file

    def self.delete_loa_file(client, order_id, file_id)
      client.make_request(:delete, client.concat_account_path("#{IMPORT_TN_ORDERS_PATH}/#{order_id}/#{LOAS_PATH}/#{file_id}"))
    end
    wrap_client_arg :delete_loa_file

    def self.get_loa_file_metadata(client, order_id, file_id)
      data = client.make_request(:get, client.concat_account_path("#{IMPORT_TN_ORDERS_PATH}/#{order_id}/#{LOAS_PATH}/#{file_id}/metadata"))
      return data
    end
    wrap_client_arg :get_loa_file_metadata

    def self.update_loa_file_metadata(client, order_id, file_id, file_metadata)
      client.make_request(:put, client.concat_account_path("#{IMPORT_TN_ORDERS_PATH}/#{order_id}/#{LOAS_PATH}/#{file_id}/metadata"), {:file_meta_data => file_metadata})
    end
    wrap_client_arg :update_loa_file_metadata

    def self.delete_loa_file_metadata(client, order_id, file_id)
      client.make_request(:delete, client.concat_account_path("#{IMPORT_TN_ORDERS_PATH}/#{order_id}/#{LOAS_PATH}/#{file_id}/metadata"))
    end
    wrap_client_arg :delete_loa_file_metadata
  end
end
