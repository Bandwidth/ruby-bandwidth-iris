describe BandwidthIris::AvailableNumber do
  client = nil
  
  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#list' do
    it 'should return numbers' do
      client.stubs.get('/v1.0/accounts/accountId/availableNumbers?areaCode=866&quantity=5') {|env| [200, {}, Helper.xml['available_numbers']]}
      expect(AvailableNumber.list(client, {:area_code => 866, :quantity => 5})).to eql([ 
        { :city => "JERSEY CITY", :lata => 224, :rate_center => "JERSEYCITY", :state => "NJ", :telephone_number => "2012001555" },
        { :city => "JERSEY CITY", :lata => 224, :rate_center => "JERSEYCITY", :state => "NJ", :telephone_number => "123123123" } 
      ])
    end
  end

end
