module BandwidthIris
  SIP_CREDENTIAL_PATH = 'sipcredentials'

  class SipCredential
    extend ClientWrapper
    include ApiItem

    def self.list(client, query = nil)
      list = client.make_request(:get, client.concat_account_path(SIP_CREDENTIAL_PATH), query)[0][:sip_credential]
      list = if list.is_a?(Array) then list else [list] end
      list.map do |i|
        SipCredential.new(i, client)
      end
    end
    wrap_client_arg :list

    def self.get(client, id)
      data = client.make_request(:get, "#{client.concat_account_path(SIP_CREDENTIAL_PATH)}/#{id}")[0]
      SipCredential.new(data[:sip_credential], client)
    end
    wrap_client_arg :get

    def self.create(client, item)
      data = client.make_request(
        :post,
        client.concat_account_path(SIP_CREDENTIAL_PATH),
        { :sip_credentials => { :sip_credential => item } }
      )[0][:valid_sip_credentials]
      SipCredential.new(data[:sip_credential], client)
    end
    wrap_client_arg :create


    def update(data)
      @client.make_request(:put,"#{@client.concat_account_path(SIP_CREDENTIAL_PATH)}/#{user_name}", {:sip_credential => data})
    end

    def delete
      @client.make_request(:delete,"#{@client.concat_account_path(SIP_CREDENTIAL_PATH)}/#{user_name}")
    end
  end
end
