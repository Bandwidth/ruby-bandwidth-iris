describe BandwidthIris::InServiceNumber do
  client = nil

  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#list' do
    it 'should return numbers' do
      client.stubs.get('/v1.0/accounts/accountId/inserviceNumbers') {|env| [200, {}, Helper.xml['in_service_numbers']]}
      list = InServiceNumber.list(client)
      expect(list.length).to eql(15)
    end
  end
  describe '#get' do
    it 'should return a number' do
      client.stubs.get('/v1.0/accounts/accountId/inserviceNumbers/12345') {|env| [200, {}, '']}
      InServiceNumber.get(client, '12345')
    end
  end
  describe '#totals' do
    it 'should return totals' do
      client.stubs.get('/v1.0/accounts/accountId/inserviceNumbers/totals') {|env| [200, {}, Helper.xml['in_service_numbers_totals']]}
      r = InServiceNumber.totals(client)
      expect(r[:count]).to eql(3)
    end
  end

end
