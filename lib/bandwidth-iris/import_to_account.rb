module BandwidthIris
  IMPORT_TO_ACCOUNT_PATH = 'importToAccounts'

  class ImportToAccount
    extend ClientWrapper
    include ApiItem

    def get_notes()
      list = @client.make_request(:get, "#{@client.concat_account_path(IMPORT_TO_ACCOUNT_PATH)}/#{id}/notes")[0][:note]
      if list.is_a?(Array)
        list
      else
        [list]
      end
    end

    def add_notes(note)
      r = @client.make_request(:post, "#{@client.concat_account_path(IMPORT_TO_ACCOUNT_PATH)}/#{id}/notes", {:note => note})
      note_id = Client.get_id_from_location_header(r[1][:location])
      (get_notes().select {|n| n[:id].to_s == note_id }).first
    end
  end
end
