module BandwidthIris
  ENG_ORDERS_PATH = 'emergencyNotificationGroupOrders'
  ENG_PATH = 'emergencyNotificationGroups'

  class EmergencyNotificationGroups
    extend ClientWrapper
    include ApiItem

    def self.create_emergency_notification_group_order

    end
    wrap_client_arg :create_emergency_notification_group_order

    def self.get_emergency_notification_group_orders

    end
    wrap_client_arg :get_emergency_notification_group_orders

    def self.get_emergency_notification_group_order

    end
    wrap_client_arg :get_emergency_notification_group_order

    def self.get_emergency_notification_group

    end
    wrap_client_arg :get_emergency_notification_group

    def self.get_emergency_notification_groups

    end
    wrap_client_arg :get_emergency_notification_groups
  end
end
