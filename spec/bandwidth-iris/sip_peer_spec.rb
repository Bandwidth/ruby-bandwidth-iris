describe BandwidthIris::SipPeer do
  client = nil

  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#list' do
    it 'should return peers' do
      client.stubs.get('/v1.0/accounts/accountId/sites/1/sippeers') {|env| [200, {}, Helper.xml['sip_peers']]}
      list = SipPeer.list(client, 1)
      expect(list.length).to eql(1)
      expect(list[0][:id]).to eql(12345)
      expect(list[0][:peer_name]).to eql("SIP Peer 1")
      expect(list[0][:description]).to eql("Sip Peer 1 description")
    end
  end

  describe '#get' do
    it 'should return a peer' do
      client.stubs.get('/v1.0/accounts/accountId/sites/1/sippeers/11') {|env| [200, {}, Helper.xml['sip_peer']]}
      item = SipPeer.get(client, 1, 11)
      expect(item[:id]).to eql(10)
      expect(item[:peer_name]).to eql("SIP Peer 1")
      expect(item[:description]).to eql("Sip Peer 1 description")
    end
  end

  describe '#create' do
    it 'should create a peer' do
      data = {:peer_name => "SIP Peer 1", :description => "Sip Peer 1 description"}
      client.stubs.post('/v1.0/accounts/accountId/sites/1/sippeers', client.build_xml({:sip_peer => data})) {|env| [201, {'Location' => '/v1.0/accounts/accountId/sites/1/sippeers/11'}, '']}
      client.stubs.get('/v1.0/accounts/accountId/sites/1/sippeers/11') {|env| [200, {}, Helper.xml['sip_peer']]}
      item = SipPeer.create(client, 1, data)
      expect(item[:id]).to eql(10)
      expect(item[:peer_name]).to eql("SIP Peer 1")
      expect(item[:description]).to eql("Sip Peer 1 description")
    end
  end

  describe '#delete' do
    it 'should remove a peer' do
      client.stubs.delete('/v1.0/accounts/accountId/sites/1/sippeers/11') {|env| [200, {}, '']}
      item = SipPeer.new({:site_id => 1, :id => 11}, client)
      item.delete()
    end
  end

  describe '#get_tns' do
    it 'should return list of numbers' do
      client.stubs.get('/v1.0/accounts/accountId/sites/1/sippeers/10/tns') {|env| [200, {}, Helper.xml['tns']]}
      item = SipPeer.new({:site_id => 1, :id => 10}, client)
      list = item.get_tns()
      expect(list.length).to eql(17)
      expect(list[0][:full_number]).to eql("3034162216")
    end
    it 'should return a number' do
      client.stubs.get('/v1.0/accounts/accountId/sites/1/sippeers/10/tns/12345') {|env| [200, {}, Helper.xml['sip_peer_tn']]}
      item = SipPeer.new({:site_id => 1, :id => 10}, client)
      item = item.get_tns('12345')
      expect(item[:full_number]).to eql("9195551212")
    end
  end

  describe '#update_tns' do
    it 'should update a number' do
      data = {:full_number => "123456", :rewrite_user => "test"}
      client.stubs.put('/v1.0/accounts/accountId/sites/1/sippeers/10/tns/123456', client.build_xml({:sip_peer_telephone_number => data})) {|env| [200, {}, '']}
      item = SipPeer.new({:site_id => 1, :id => 10}, client)
      item.update_tns('123456', data)
    end
  end

  describe '#move_tns' do
    it 'should move  numbers' do
      data = ["11111", "22222"]
      client.stubs.post('/v1.0/accounts/accountId/sites/1/sippeers/10/movetns', client.build_xml({:sip_peer_telephone_numbers => {:full_number => data}})) {|env| [200, {}, '']}
      item = SipPeer.new({:site_id => 1, :id => 10}, client)
      item.move_tns(data)
    end
  end
end
