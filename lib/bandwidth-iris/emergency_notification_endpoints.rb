module BandwidthIris
  ENE_ORDERS_PATH = 'emergencyNotificationEndpointOrders'

  class EmergencyNotificationEndpoints
    extend ClientWrapper
    include ApiItem

    def self.create_emergency_notification_endpoint_order

    end
    wrap_client_arg :create_emergency_notification_endpoint_order

    def self.get_emergency_notification_endpoint_orders

    end
    wrap_client_arg :get_emergency_notification_endpoint_orders

    def self.get_emergency_notification_endpoint_order

    end
    wrap_client_arg :get_emergency_notification_endpoint_order
  end
end

