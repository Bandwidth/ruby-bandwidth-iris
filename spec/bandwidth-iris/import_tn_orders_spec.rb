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
end
