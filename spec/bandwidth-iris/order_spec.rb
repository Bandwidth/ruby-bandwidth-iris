describe BandwidthIris::Order do
  client = nil

  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#create' do
    it 'should create an order' do
      data = {
        :name => "Test",
        :siteId => "10",
        :customerOrderId => "11",
        :lataSearchAndOrderType => {
          :lata => "224",
          :quantity => 1
        }
      }
      client.stubs.post("/v1.0/accounts/accountId/orders", client.build_xml({:order => data})){|env| [200, {},  Helper.xml['order']]}
      order = Order.create(client, data)
      expect(order.id).to eql(101)
      expect(order.name).to eql("Test")
    end
  end

  describe '#get' do
    it 'should return an order' do
      client.stubs.get("/v1.0/accounts/accountId/orders/101"){|env| [200, {}, Helper.xml['order']]}
      order = Order.get(client, "101")
      expect(order.id).to eql(101)
      expect(order.name).to eql("Test")
    end
  end

  describe '#list' do
    it 'should return orders' do
      client.stubs.get("/v1.0/accounts/accountId/orders"){|env| [200, {}, Helper.xml['orders']]}
      list = Order.list(client)
      expect(list.length).to eql(1)
    end
  end

  describe '#update' do
    it 'should update an order' do
      data = { :name => "Test",  :close_order => true }
      client.stubs.put("/v1.0/accounts/accountId/orders/101", client.build_xml(:order => data)){|env| [200, {}, '']}
      item = Order.new({:id => 101}, client)
      item.update(data)
    end
  end

  describe '#get_notes' do
    it 'should return notes' do
      client.stubs.get('/v1.0/accounts/accountId/orders/1/notes') {|env| [200, {}, Helper.xml['notes']]}
      order = Order.new({:id => 1}, client)

      list = order.get_notes()
      expect(list[0][:id]).to eql(11299)
      expect(list[0][:user_id]).to eql('customer')
      expect(list[0][:description]).to eql('Test')
    end
  end

  describe '#add_notes' do
    it 'should add a note and return it' do
      data = {:user_id => 'customer', :description => 'Test'}
      client.stubs.post('/v1.0/accounts/accountId/orders/1/notes', client.build_xml({note: data})) {|env| [200, {:location => '/v1.0/accounts/FakeAccountId/orders/1/notes/11299'}, '']}
      client.stubs.get('/v1.0/accounts/accountId/orders/1/notes') {|env| [200, {}, Helper.xml['notes']]}
      order = Order.new({:id => 1}, client)
      item = order.add_notes(data)
      expect(item[:id]).to eql(11299)
      expect(item[:user_id]).to eql('customer')
      expect(item[:description]).to eql('Test')
    end
  end

  describe '#get_area_codes' do
    it 'should return codes' do
      client.stubs.get('/v1.0/accounts/accountId/orders/1/areaCodes') {|env| [200, {}, Helper.xml['order_area_codes']]}
      order = Order.new({:id => 1}, client)
      list = order.get_area_codes()
      expect(list.length).to eql(1)
    end
  end

  describe '#get_npa_nxx' do
    it 'should return codes' do
      client.stubs.get('/v1.0/accounts/accountId/orders/1/npaNxx') {|env| [200, {}, Helper.xml['order_npa_nxx']]}
      order = Order.new({:id => 1}, client)
      list = order.get_npa_npx()
      expect(list.length).to eql(1)
    end
  end

  describe '#get_totals' do
    it 'should return totals' do
      client.stubs.get('/v1.0/accounts/accountId/orders/1/totals') {|env| [200, {}, Helper.xml['order_totals']]}
      order = Order.new({:id => 1}, client)
      list = order.get_totals()
      expect(list.length).to eql(1)
    end
  end

  describe '#get_history' do
    it 'should return history' do
      client.stubs.get('/v1.0/accounts/accountId/orders/1/history') {|env| [200, {}, Helper.xml['order_history']]}
      order = Order.new({:id => 1}, client)
      list = order.get_history()
      expect(list.length).to eql(2)
    end
  end

  describe '#get_tns' do
    it 'should return tns' do
      client.stubs.get('/v1.0/accounts/accountId/orders/1/tns') {|env| [200, {}, Helper.xml['order_tns']]}
      order = Order.new({:id => 1}, client)
      order.get_tns()
    end
  end
end
