describe BandwidthIris::Subscription do
  client = nil

  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#list' do
    it 'should return subscriptions' do
      client.stubs.get('/v1.0/accounts/accountId/subscriptions') {|env| [200, {}, Helper.xml['subscriptions']]}
      list = Subscription.list(client)
      expect(list.length).to eql(1)
      expect(list[0][:id]).to eql(1)
      expect(list[0][:order_type]).to eql('orders')
    end
  end

  describe '#get' do
    it 'should return a subscription' do
      client.stubs.get('/v1.0/accounts/accountId/subscriptions/1') {|env| [200, {}, Helper.xml['subscriptions']]}
      item = Subscription.get(client, 1)
      expect(item[:id]).to eql(1)
      expect(item[:order_type]).to eql('orders')
    end
  end

  describe '#create' do
    it 'should create a subscription' do
      data = {:name => "test", :description => "test"}
      client.stubs.post('/v1.0/accounts/accountId/subscriptions', client.build_xml({:subscription => data})) {|env| [200, {'Location' => '/v1.0/accounts/accountId/subscriptions/1'}, '']}
      client.stubs.get('/v1.0/accounts/accountId/subscriptions/1') {|env| [200, {}, Helper.xml['subscriptions']]}
      item = Subscription.create(client, data)
      expect(item[:id]).to eql(1)
      expect(item[:order_type]).to eql('orders')
    end
  end

  describe '#update' do
    it 'should update a subscription' do
      data = {:description => "test"}
      client.stubs.put('/v1.0/accounts/accountId/subscriptions/1', client.build_xml({:subscription => data})) {|env| [200, {}, '']}
      item = Subscription.new({:id => 1}, client)
      item.update(data)
    end
  end

  describe '#delete' do
    it 'should remove a subscription' do
      client.stubs.delete('/v1.0/accounts/accountId/subscriptions/1') {|env| [200, {}, '']}
      item = Subscription.new({:id => 1}, client)
      item.delete()
    end
  end
end
