module BandwidthIris
  PORT_IN_PATH = 'portins'
  LOAS_PATH = 'loas'

  class PortIn
    extend ClientWrapper
    include ApiItem

    def self.create(client, item)
      item  = client.make_request(:post, client.concat_account_path(PORT_IN_PATH), {:lnp_order => item})[0]
      item[:id] = item[:order_id]
      PortIn.new(item, client)
    end
    wrap_client_arg :create


    def update(data)
      @client.make_request(:put,"#{@client.concat_account_path(PORT_IN_PATH)}/#{id}", {:lnp_order_supp => data})
    end

    def delete()
      @client.make_request(:delete,"#{@client.concat_account_path(PORT_IN_PATH)}/#{id}")
    end

    def get_notes()
      list = @client.make_request(:get, "#{@client.concat_account_path(PORT_IN_PATH)}/#{id}/notes")[0][:note]
      return [] if !list
      if list.is_a?(Array)
        list
      else
        [list]
      end
    end

    def add_notes(note)
      r = @client.make_request(:post, "#{@client.concat_account_path(PORT_IN_PATH)}/#{id}/notes", {:note => note})
      note_id = Client.get_id_from_location_header(r[1][:location])
      (get_notes().select {|n| n[:id].to_s == note_id }).first
    end

    def create_file(io, media_type = nil)
      connection = @client.create_connection()
      # FIXME use streams directly when Faraday will support streaming
      buf = io.read()
      response = connection.post("/#{@client.api_version}#{@client.concat_account_path(PORT_IN_PATH)}/#{id}/#{LOAS_PATH}") do |req|
        req.headers['Content-Length'] = buf.size.to_s
        req.headers['Content-Type'] = media_type || 'application/octet-stream'
        req.body = buf
      end
      r = @client.check_response(response)
      r[:filename]
    end

    def update_file(file_name, file, media_type)
      connection = @client.create_connection()
      # FIXME use streams directly when Faraday will support streaming
      buf = io.read()
      response = connection.put("/#{@client.api_version}#{@client.concat_account_path(PORT_IN_PATH)}/#{id}/#{LOAS_PATH}/#{URI.encode(file_name)}") do |req|
        req.headers['Content-Length'] = buf.size.to_s
        req.headers['Content-Type'] = media_type || 'application/octet-stream'
        req.body = buf
      end
      @client.check_response(response)
    end

    def get_file_metadata(file_name)
      @client.make_request(:get, "#{@client.concat_account_path(PORT_IN_PATH)}/#{id}/#{LOAS_PATH}/#{CGI.escape(file_name)}/metadata")[0]
    end

    def get_file(file_name)
      connection = @client.create_connection()
      response = connection.get("/#{@client.api_version}#{@client.concat_account_path(PORT_IN_PATH)}/#{id}/#{LOAS_PATH}/#{CGI.escape(file_name)}")
      [response.body, response.headers['Content-Type'] || 'application/octet-stream']
    end

    def get_files(metadata = false)
       @client.make_request(:get, "#{@client.concat_account_path(PORT_IN_PATH)}/#{id}/#{LOAS_PATH}", {:metadata => metadata})[0][:file_data]
    end
  end
end
