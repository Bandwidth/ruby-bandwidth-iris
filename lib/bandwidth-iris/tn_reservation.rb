module BandwidthIris
  TN_RESERVATION_PATH = 'tnreservation'

  class TnReservation
    extend ClientWrapper
    include ApiItem


    def self.get(client, id)
      data  = client.make_request(:get, "#{client.concat_account_path(TN_RESERVATION_PATH)}/#{id}")[0][:reservation]
      TnReservation.new(data, client)
    end
    wrap_client_arg :get

    def self.create(client, item)
      location = client.make_request(:post, client.concat_account_path(TN_RESERVATION_PATH), {:tn_reservation => item})[1][:location]
      id = Client.get_id_from_location_header(location)
      self.get(client, id)
    end
    wrap_client_arg :create

    def delete()
      @client.make_request(:delete,"#{@client.concat_account_path(TN_RESERVATION_PATH)}/#{id}")
    end
  end
end
