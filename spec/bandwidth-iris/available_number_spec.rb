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
      expect(AvailableNumber.list(client, {:area_code => 866, :quantity => 5}).length).to eql(2)
    end

    it 'should return number details' do
      client.stubs.get('/v1.0/accounts/accountId/availableNumbers?areaCode=201&quantity=5&enableTNDetail=true') {|env| [200, {}, Helper.xml['available_number_details']]}
      expect(AvailableNumber.list(client, {:area_code => 201, :quantity => 5, :enable_t_n_detail => true}).length).to eql(5)
      expect(AvailableNumber.list(client, {:area_code => 201, :quantity => 5, :enable_t_n_detail => true})[0]).to be_a(Hash)
      expect(AvailableNumber.list(client, {:area_code => 201, :quantity => 5, 'enableTNDetail' => true}).length).to eql(5)
      expect(AvailableNumber.list(client, {:area_code => 201, :quantity => 5, 'enableTNDetail' => true})[0]).to be_a(Hash)
    end
  end

end
