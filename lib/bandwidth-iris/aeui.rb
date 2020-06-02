module BandwidthIris
  AEUI_PATH = 'aeuis'

  class AlternateEndUserIdentity
    extend ClientWrapper
    include ApiItem

    def self.get_alternate_end_user_information(client, query=nil)
      response = client.make_request(:get, "#{client.concat_account_path(AEUI_PATH)}", query)
      return response[0]
    end
    wrap_client_arg :get_alternate_end_user_information    

    def self.get_alternate_caller_information(client, acid)
      response = client.make_request(:get, "#{client.concat_account_path(AEUI_PATH)}/#{acid}")
      return response[0][:alternate_end_user_identifier]
    end
    wrap_client_arg :get_alternate_caller_information
  end
end
