module BandwidthIris
  TN_PATH = 'tns'

  class Tn
    extend ClientWrapper
    include ApiItem

    def self.get(client, number)
      data  = client.make_request(:get, "#{TN_PATH}/#{CGI.escape(number)}")[0]
      Tn.new(data, client)
    end
    wrap_client_arg :get


    def self.list(client, query = nil)
      list = client.make_request(:get, TN_PATH, query)[0][:telephone_numbers][:telephone_number]
      return [] if !list
      list = if list.is_a?(Array) then list else [list] end
      list.map do |i|
        Tn.new(i, client)
      end
    end
    wrap_client_arg :list

    def get_sites()
      @client.make_request(:get, "#{TN_PATH}/#{CGI.escape(telephone_number)}/sites")[0]
    end

    def get_sip_peers()
      @client.make_request(:get, "#{TN_PATH}/#{CGI.escape(telephone_number)}/sippeers")[0]
    end

    def get_rate_center()
      @client.make_request(:get, "#{TN_PATH}/#{CGI.escape(telephone_number)}/ratecenter")[0][:telephone_number_details]
    end

    def get_details()
      @client.make_request(:get, "#{TN_PATH}/#{CGI.escape(telephone_number)}/tndetails")[0][:telephone_number_details]
    end

    def move(params)
      @client.make_request(
        :post,
        @client.concat_account_path("moveTns"),
        MoveTnsOrder: params.merge(TelephoneNumbers: { TelephoneNumber: telephone_number })
      )
    end
  end
end
