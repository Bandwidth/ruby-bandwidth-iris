describe BandwidthIris::AvailableNpaNxx do
  client = nil

  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#list' do
    it 'should return data' do
      client.stubs.get('/v1.0/accounts/accountId/availableNpaNxx?areaCode=919') {|env| [200, {}, Helper.xml['available_npa_nxx']]}
      expect(AvailableNpaNxx.list(client, {:area_code => 919})).to eql([
        { :city => "City1", :state => "State1", :npa => "Npa1", :nxx => "Nxx1", :quantity => 10 },
        { :city => "City2", :state => "State2", :npa => "Npa2", :nxx => "Nxx2", :quantity => 20 }
      ])
    end
  end

end
