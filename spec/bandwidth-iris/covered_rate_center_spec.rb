describe BandwidthIris::CoveredRateCenter do
  client = nil

  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#list' do
    it 'should return centers' do
      client.stubs.get('/v1.0/coveredRateCenters') {|env| [200, {}, Helper.xml['covered_rate_centers']]}
      list = CoveredRateCenter.list(client)
      expect(list.length).to eql(1)
      expect(list[0][:abbreviation]).to eql("ACME")
      expect(list[0][:name]).to eql("ACME")
    end
  end

end
