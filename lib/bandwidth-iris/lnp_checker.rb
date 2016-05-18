module BandwidthIris
  LNP_CHECKER_PATH = 'lnpchecker'

  class LnpChecker
    extend ClientWrapper

    def self.check(client, numbers, full_check = false)
      list = if numbers.is_a?(Array) then numbers else [numbers] end
      data = {
        :number_portability_request => {
          :tn_list => {:tn => list}
        }
      }
      client.make_request(:post, "#{client.concat_account_path(LNP_CHECKER_PATH)}?fullCheck=#{full_check}", data)[0]
    end
    wrap_client_arg :check

  end
end
