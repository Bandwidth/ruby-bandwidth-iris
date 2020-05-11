module BandwidthIris
  APPLICATIONS_PATH = "applications"

  class Applications
    extend ClientWrapper
    include ApiItem

    def self.get_applications(client)
      data = client.make_request(:get, client.concat_account_path(APPLICATIONS_PATH))
      return data
    end
    wrap_client_arg :get_applications

    def self.create_application(client, application_data)
      data = client.make_request(:post, client.concat_account_path(APPLICATIONS_PATH), {:application => application_data})
      return data
    end
    wrap_client_arg :create_application

    def self.get_application_info(client, application_id)
      data = client.make_request(:get, client.concat_account_path("#{APPLICATIONS_PATH}/#{application_id}"))
      return data
    end
    wrap_client_arg :get_application_info

    def self.partial_update_application(client, application_id, application_data)
      data = client.make_request(:patch, client.concat_account_path("#{APPLICATIONS_PATH}/#{application_id}"), {:application => application_data})
      return data
    end
    wrap_client_arg :partial_update_application

    def self.complete_update_application(client, application_id, application_data)
      data = client.make_request(:put, client.concat_account_path("#{APPLICATIONS_PATH}/#{application_id}"), {:application => application_data})
      return data
    end
    wrap_client_arg :complete_update_application

    def self.remove_application(client, application_id)
      client.make_request(:delete, client.concat_account_path("#{APPLICATIONS_PATH}/#{application_id}"))
    end
    wrap_client_arg :remove_application

    def self.list_application_sippeers(client, application_id)
      data = client.make_request(:get, client.concat_account_path("#{APPLICATIONS_PATH}/#{application_id}/associatedsippeers"))
      return data
    end
    wrap_client_arg :list_application_sippeers
  end
end
