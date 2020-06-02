module BandwidthIris
  ENG_ORDERS_PATH = 'emergencyNotificationGroupOrders'
  ENG_PATH = 'emergencyNotificationGroups'

  class EmergencyNotificationGroups
    extend ClientWrapper
    include ApiItem

    def self.create_emergency_notification_group_order(client, data)
      response = client.make_request(:post, "#{client.concat_account_path(ENG_ORDERS_PATH)}", {:emergency_notification_group_order => data})
      return response[0]
    end
    wrap_client_arg :create_emergency_notification_group_order

    def self.get_emergency_notification_group_orders(client, query=nil)
      response = client.make_request(:get, "#{client.concat_account_path(ENG_ORDERS_PATH)}", query)
      return response[0]
    end
    wrap_client_arg :get_emergency_notification_group_orders

    def self.get_emergency_notification_group_order(client, order_id)
      response = client.make_request(:get, "#{client.concat_account_path(ENG_ORDERS_PATH)}/#{order_id}")
      return response[0][:emergency_notification_group]
    end
    wrap_client_arg :get_emergency_notification_group_order

    def self.get_emergency_notification_group(client, eng_id)
      response = client.make_request(:get, "#{client.concat_account_path(ENG_PATH)}/#{eng_id}")
      return response[0][:emergency_notification_group]
    end
    wrap_client_arg :get_emergency_notification_group

    def self.get_emergency_notification_groups(client, query=nil)
      response = client.make_request(:get, "#{client.concat_account_path(ENG_PATH)}", query)
      return response[0]
    end
    wrap_client_arg :get_emergency_notification_groups
  end
end
