describe BandwidthIris::RateCenter do
  client = nil

  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#list' do
    it 'should return rate centes' do
      client.stubs.get('/v1.0/rateCenters') {|env| [200, {}, Helper.xml['rate_centers']]}
      list = RateCenter.list(client)
      expect(list.length).to eql(3)
      expect(list[0][:abbreviation]).to eql("ACME")
      expect(list[0][:name]).to eql("ACME")
    end
  end

  it 'should return rate centes (with 1 element)' do
    client.stubs.get('/v1.0/rateCenters') {|env| [200, {}, Helper.xml['rate_centers1']]}
    list = RateCenter.list(client)
    expect(list.length).to eql(1)
    expect(list[0][:abbreviation]).to eql("ACME")
    expect(list[0][:name]).to eql("ACME")
  end
end
