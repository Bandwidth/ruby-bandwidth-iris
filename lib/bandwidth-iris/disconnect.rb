module BandwidthIris
  DISCONNECT_PATH = 'disconnects'

  class Disconnect
    extend ClientWrapper
    include ApiItem

    def self.create(client, order_name, numbers)
      data = {
        :disconnect_telephone_number_order =>{
          :name => order_name,
          '_nameXmlElement' => 'name',
          :disconnect_telephone_number_order_type => {
              :telephone_number_list => {
                :telephone_number => numbers
              }
            }
        }
      }
      client.make_request(:post, client.concat_account_path(DISCONNECT_PATH), data)[0]
    end
    wrap_client_arg :create

    def get_notes()
      list = @client.make_request(:get, "#{@client.concat_account_path(DISCONNECT_PATH)}/#{id}/notes")[0][:note]
      return [] if !list
      if list.is_a?(Array)
        list
      else
        [list]
      end
    end

    def add_notes(note)
      r = @client.make_request(:post, "#{@client.concat_account_path(DISCONNECT_PATH)}/#{id}/notes", {:note => note})
      note_id = Client.get_id_from_location_header(r[1][:location])
      (get_notes().select {|n| n[:id].to_s == note_id }).first
    end
  end
end
