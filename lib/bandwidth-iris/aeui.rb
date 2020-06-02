module BandwidthIris
  AEUI_PATH = 'aeuis'

  class AlternateEndUserIdentity
    extend ClientWrapper
    include ApiItem

    def self.get_alternate_end_user_information
    
    end
    wrap_client_arg :get_alternate_end_user_information    

    def self.get_alternate_caller_information
    
    end
    wrap_client_arg :get_alternate_caller_information
  end
end
