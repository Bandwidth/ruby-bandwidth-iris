describe BandwidthIris::Dlda do
  client = nil

  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#list' do
    it 'should return orders' do
      client.stubs.get('/v1.0/accounts/accountId/dldas') {|env| [200, {}, Helper.xml['dldas']]}
      list = Dlda.list(client)
      expect(list.length).to eql(3)
    end
  end

  describe '#get' do
    it 'should return an order' do
      client.stubs.get('/v1.0/accounts/accountId/dldas/1') {|env| [200, {}, Helper.xml['dlda']]}
      item = Dlda.get(client, 1)
      expect(item[:id]).to eql('ea9e90c2-77a4-4f82-ac47-e1c5bb1311f4')
    end
  end

  describe '#create' do
    it 'should create a subscription' do
      data = {}
      client.stubs.post('/v1.0/accounts/accountId/dldas', client.build_xml({:dlda_order => data})) {|env| [201, {'Location' => '/v1.0/accounts/accountId/dldas/1'}, '']}
      client.stubs.get('/v1.0/accounts/accountId/dldas/1') {|env| [200, {}, Helper.xml['dlda']]}
      item = Dlda.create(client, data)
      expect(item[:id]).to eql('ea9e90c2-77a4-4f82-ac47-e1c5bb1311f4')
    end
  end

  describe '#get_history' do
    it 'should return history' do
      client.stubs.get('/v1.0/accounts/accountId/dldas/1/history') {|env| [200, {}, Helper.xml['order_history']]}
      item = Dlda.new({:id => 1}, client)
      list = item.get_history()
      expect(list.length > 0).to eql(true)
    end
  end

end
