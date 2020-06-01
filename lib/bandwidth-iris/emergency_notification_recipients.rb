module BandwidthIris
  ENR_PATH = 'emergencyNotificationRecipients'

  class EmergencyNotificationRecipients
    extend ClientWrapper
    include ApiItem

    def self.create_emergency_notification_recipient

    end
    wrap_client_arg :create_emergency_notification_recipient

    def self.get_emergency_notification_recipients

    end
    wrap_client_arg :get_emergency_notification_recipients

    def self.get_emergency_notification_recipient

    end
    wrap_client_arg :get_emergency_notification_recipient

    def self.replace_emergency_notification_recipient

    end
    wrap_client_arg :replace_emergency_notification_recipient

    def self.delete_emergency_notification_recipient

    end
    wrap_client_arg :delete_emergency_notification_recipient
  end
end
