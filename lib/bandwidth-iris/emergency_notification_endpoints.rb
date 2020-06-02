module BandwidthIris
  ENE_ORDERS_PATH = 'emergencyNotificationEndpointOrders'

  class EmergencyNotificationEndpoints
    extend ClientWrapper
    include ApiItem

    def self.create_emergency_notification_endpoint_order(client, data)
      response = client.make_request(:post, "#{client.concat_account_path(ENE_ORDERS_PATH)}", {:emergency_notification_endpoint_order => data})
      return response[0][:emergency_notification_endpoint_order]
    end
    wrap_client_arg :create_emergency_notification_endpoint_order

    def self.get_emergency_notification_endpoint_orders(client, query=nil)
      response = client.make_request(:get, "#{client.concat_account_path(ENE_ORDERS_PATH)}", query)
      return response[0]
    end
    wrap_client_arg :get_emergency_notification_endpoint_orders

    def self.get_emergency_notification_endpoint_order(client, order_id)
      response = client.make_request(:get, "#{client.concat_account_path(ENE_ORDERS_PATH)}/#{order_id}")
      return response[0][:emergency_notification_endpoint_order]
    end
    wrap_client_arg :get_emergency_notification_endpoint_order
  end
end
