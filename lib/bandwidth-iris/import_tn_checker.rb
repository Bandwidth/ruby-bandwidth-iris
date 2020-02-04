module BandwidthIris
  IMPORT_TN_CHECKER_PATH = "importTnChecker"

  class ImportTnChecker
    extend ClientWrapper
    include ApiItem

    def self.check_tns_portability(client, tns)
      data = client.make_request(:post, client.concat_account_path("#{IMPORT_TN_CHECKER_PATH}"), {:import_tn_checker_payload => tns})
      return data
    end
    wrap_client_arg :check_tns_portability
  end
end
