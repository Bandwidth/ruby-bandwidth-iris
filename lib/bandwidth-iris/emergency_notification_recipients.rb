module BandwidthIris
  ENR_PATH = 'emergencyNotificationRecipients'

  class EmergencyNotificationRecipients
    extend ClientWrapper
    include ApiItem

    def self.create_emergency_notification_recipient(client, data)
      response = client.make_request(:post, "#{client.concat_account_path(ENR_PATH)}", {:emergency_notification_recipient => data})
      return response[0][:emergency_notification_recipient]
    end
    wrap_client_arg :create_emergency_notification_recipient

    def self.get_emergency_notification_recipients(client, query=nil)
      response = client.make_request(:get, "#{client.concat_account_path(ENR_PATH)}", query)
      return response[0]
    end
    wrap_client_arg :get_emergency_notification_recipients

    def self.get_emergency_notification_recipient(client, enr_id)
      response = client.make_request(:get, "#{client.concat_account_path(ENR_PATH)}/#{enr_id}")
      return response[0][:emergency_notification_recipient]
    end
    wrap_client_arg :get_emergency_notification_recipient

    def self.replace_emergency_notification_recipient(client, enr_id, data)
      response = client.make_request(:put, "#{client.concat_account_path(ENR_PATH)}/#{enr_id}", {:emergency_notification_recipient => data})
      return response[0][:emergency_notification_recipient]
    end
    wrap_client_arg :replace_emergency_notification_recipient

    def self.delete_emergency_notification_recipient(client, enr_id)
      client.make_request(:delete, "#{client.concat_account_path(ENR_PATH)}/#{enr_id}")
    end
    wrap_client_arg :delete_emergency_notification_recipient
  end
end
