describe BandwidthIris::TnReservation do
  client = nil

  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#get' do
    it 'should return a reservation' do
      client.stubs.get('/v1.0/accounts/accountId/tnreservation/1') {|env| [200, {}, Helper.xml['tn_reservation']]}
      item = TnReservation.get(client, 1)
      expect(item[:id]).to eql(1)
      expect(item[:account_id]).to eql(111)
    end
  end

  describe '#create' do
    it 'should create a reservation' do
      data = {:account_id => "111", :reserved_tn => "000"}
      client.stubs.post('/v1.0/accounts/accountId/tnreservation', client.build_xml({:tn_reservation => data})) {|env| [200, {'Location' => '/v1.0/accounts/accountId/tnreservations/1'}, '']}
      client.stubs.get('/v1.0/accounts/accountId/tnreservation/1') {|env| [200, {}, Helper.xml['tn_reservation']]}
      item = TnReservation.create(client, data)
      expect(item[:id]).to eql(1)
      expect(item[:account_id]).to eql(111)
    end
  end

  describe '#delete' do
    it 'should remove a reservation' do
      client.stubs.delete('/v1.0/accounts/accountId/tnreservation/1') {|env| [200, {}, '']}
      item = TnReservation.new({:id => 1}, client)
      item.delete()
    end
  end
end
