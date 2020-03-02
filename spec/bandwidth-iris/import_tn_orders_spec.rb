describe BandwidthIris::ImportTnOrders do
  client = nil

  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#create' do
    it 'should get an order' do
      client.stubs.get('/v1.0/accounts/accountId/importtnorders', {}) {|env| [200, {}, '']}
      item = ImportTnOrders.get_import_tn_orders(client)
    end
  end

  describe '#get' do
    it 'should get an order' do
      order = "123"
      client.stubs.get("/v1.0/accounts/accountId/importtnorders/#{order}", {}) {|env| [200, {}, '']}
      item = ImportTnOrders.get_import_tn_order(client, order)
    end
  end

  describe '#get history' do
    it 'should get an order history' do
      order = "123"
      client.stubs.get("/v1.0/accounts/accountId/importtnorders/#{order}/history", {}) {|env| [200, {}, '']}
      item = ImportTnOrders.get_import_tn_order_history(client, order)
    end
  end

  describe '#create order' do
    it 'should create new order' do
      data = {
          :id => "id"
      }
      client.stubs.post("/v1.0/accounts/accountId/importtnorders", client.build_xml({:import_tn_order => data})) {|env| [200, {}, '']}
      item = ImportTnOrders.create_import_tn_order(client, data)
    end
  end

  describe '#get loa files' do
    it 'should get loa files' do
      order = "123"
      client.stubs.get("/v1.0/accounts/accountId/importtnorders/#{order}/loas") {|env| [200, {}, '']}
      item = ImportTnOrders.get_loa_files(client, order)
    end
  end

  describe '#upload loa file' do
    it 'should upload loa file' do
      file = '12345'
      mime_type = 'text/plain'
      order = '123'
      client.stubs.post("/v1.0/accounts/accountId/importtnorders/#{order}/loas", file) {|env| [200, {}, '']}
      item = ImportTnOrders.upload_loa_file(client, order, file, mime_type)
    end
  end

  describe '#download loa file' do
    it 'should download loa file' do
      order = "123"
      file_id = "456"
      client.stubs.get("/v1.0/accounts/accountId/importtnorders/#{order}/loas/#{file_id}") {|env| [200, {}, '']}
      item = ImportTnOrders.download_loa_file(client, order, file_id)
    end
  end

  describe '#replace loa file' do
    it 'should replace loa file' do
      file = '12345'
      mime_type = 'text/plain'
      order = '123'
      file_id = '456'
      client.stubs.put("/v1.0/accounts/accountId/importtnorders/#{order}/loas/#{file_id}", file) {|env| [200, {}, '']}
      item = ImportTnOrders.replace_loa_file(client, order, file_id, file, mime_type)
    end
  end

  describe '#delete loa file' do
    it 'should delete loa file' do
      order = '123'
      file_id = '456'
      client.stubs.delete("/v1.0/accounts/accountId/importtnorders/#{order}/loas/#{file_id}") {|env| [200, {}, '']}
      item = ImportTnOrders.delete_loa_file(client, order, file_id)
    end
  end

  describe '#get loa file metadata' do
    it 'should get loa file metadata' do
      order = "123"
      file_id = "456"
      client.stubs.get("/v1.0/accounts/accountId/importtnorders/#{order}/loas/#{file_id}/metadata") {|env| [200, {}, '']}
      item = ImportTnOrders.get_loa_file_metadata(client, order, file_id)
    end
  end
  
  describe '#update loa file metadata' do
    it 'should update loa file metadata' do
      data = {
        :test => "1234"
      }
      order = "123"
      file_id = "456"
      client.stubs.put("/v1.0/accounts/accountId/importtnorders/#{order}/loas/#{file_id}/metadata", client.build_xml({:file_meta_data => data})) {|env| [200, {}, '']}
      item = ImportTnOrders.update_loa_file_metadata(client, order, file_id, data)
    end
  end

  describe '#delete loa file metadata' do
    it 'should delete loa file metadata' do
      order = "123"
      file_id = "456"
      client.stubs.delete("/v1.0/accounts/accountId/importtnorders/#{order}/loas/#{file_id}/metadata") {|env| [200, {}, '']}
      item = ImportTnOrders.delete_loa_file_metadata(client, order, file_id)
    end
  end

end
