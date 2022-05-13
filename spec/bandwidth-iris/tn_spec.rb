describe BandwidthIris::Tn do
  client = nil

  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#list' do
    it 'should return numbers' do
      client.stubs.get('/v1.0/tns?city=CARY') {|env| [200, {}, Helper.xml['tns']]}
      list = Tn.list(client, {:city => 'CARY'})
      expect(list.length).to eql(2)
      expect(list[0][:city]).to eql('CARY')
    end
  end

  describe '#get' do
    it 'should return a number' do
      client.stubs.get('/v1.0/tns/1234') {|env| [200, {}, Helper.xml['tn']]}
      item = Tn.get(client, '1234')
      expect(item[:telephone_number]).to eql(1234)
      expect(item[:status]).to eql('Inservice')
    end
  end

  describe '#move' do
    it 'should move a number' do
      client.stubs.get('/v1.0/tns/1234') {|env| [200, {}, Helper.xml['tn']]}
      tn = Tn.get(client, '1234')
      client.stubs.post('/v1.0/accounts/accountId/moveTns') {|env| [201, {}, Helper.xml['tn_move']]}
      order = tn.move({'SiteId': 12345, 'SipPeerId': 123450})[0][:move_tns_order]
      expect(order[:created_by_user]).to eql('userapi')
      expect(order[:order_id]).to eql('55689569-86a9-fe40-ab48-f12f6c11e108')
      expect(order[:sip_peer_id]).to eql(123450)
      expect(order[:site_id]).to eql(12345)
    end
  end

  describe '#get_sites' do
    it 'should return sites' do
      client.stubs.get('/v1.0/tns/1234/sites') {|env| [200, {}, Helper.xml['tn_sites']]}
      item = Tn.new({:telephone_number => '1234'}, client)
      r = item.get_sites()
      expect(r[:id]).to eql(1435)
      expect(r[:name]).to eql('Sales Training')
    end
  end

  describe '#get_sip_peers' do
    it 'should return sip peers' do
      client.stubs.get('/v1.0/tns/1234/sippeers') {|env| [200, {}, Helper.xml['tn_sip_peers']]}
      item = Tn.new({:telephone_number => '1234'}, client)
      r = item.get_sip_peers()
      expect(r[:id]).to eql(4064)
      expect(r[:name]).to eql('Sales')
    end
  end

  describe '#get_rate_center' do
    it 'should return a rate center' do
      client.stubs.get('/v1.0/tns/1234/ratecenter') {|env| [200, {}, Helper.xml['tn_rate_center']]}
      item = Tn.new({:telephone_number => '1234'}, client)
      r = item.get_rate_center()
      expect(r[:state]).to eql('CO')
      expect(r[:rate_center]).to eql('DENVER')
    end
  end

  describe '#get_tn_details' do
    it 'should return details' do
      client.stubs.get('/v1.0/tns/1234/tndetails') {|env| [200, {}, Helper.xml['tn_details']]}
      item = Tn.new({:telephone_number => '1234'}, client)
      r = item.get_details()
      expect(r[:state]).to eql('NJ')
    end
  end
end
