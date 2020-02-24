module BandwidthIris
  CSR_PATH = 'csrs'

  class Csr
    extend ClientWrapper
    include ApiItem

    def self.create(client, csr_data)
      data = client.make_request(:post, client.concat_account_path("#{CSR_PATH}"), {:csr => csr_data})
      return data
    end
    wrap_client_arg :create

    def self.get(client, csr_id)
      data = client.make_request(:get, client.concat_account_path("#{CSR_PATH}/#{csr_id}"))
      return data
    end
    wrap_client_arg :get

    def self.replace(client, csr_id, csr_data)
      data = client.make_request(:put, client.concat_account_path("#{CSR_PATH}/#{csr_id}"), {:csr => csr_data})
      return data
    end
    wrap_client_arg :create

    def self.get_notes(client, csr_id)
      data = client.make_request(:get, client.concat_account_path("#{CSR_PATH}/#{csr_id}/notes"))
      return data
    end
    wrap_client_arg :get_notes

    def self.add_note(client, csr_id, note_data)
      data = client.make_request(:post, client.concat_account_path("#{CSR_PATH}/#{csr_id}/notes"), {:note => note_data})
      return data
    end
    wrap_client_arg :add_note

    def self.update_note(client, csr_id, note_id, note_data)
      data = client.make_request(:put, client.concat_account_path("#{CSR_PATH}/#{csr_id}/notes/#{note_id}"), {:note => note_data})
      return data
    end
    wrap_client_arg :update_node
