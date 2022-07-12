describe BandwidthIris::Site do
  client = nil

  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#list' do
    it 'should return sites' do
      client.stubs.get('/v1.0/accounts/accountId/sites') {|env| [200, {}, Helper.xml['sites']]}
      list = Site.list(client)
      expect(list.length).to eql(1)
      expect(list[0][:id]).to eql(1)
      expect(list[0][:name]).to eql('Test Site')
      expect(list[0][:description]).to eql('A site description')
    end
  end

  describe '#get' do
    it 'should return a site' do
      client.stubs.get('/v1.0/accounts/accountId/sites/1') {|env| [200, {}, Helper.xml['site']]}
      item = Site.get(client, 1)
      expect(item[:id]).to eql(1)
      expect(item[:name]).to eql('Test Site')
      expect(item[:description]).to eql('A Site Description')
    end
  end

  describe '#create' do
    it 'should create a site' do
      data = {:name => "test", :description => "test"}
      client.stubs.post('/v1.0/accounts/accountId/sites', client.build_xml({:site => data})) {|env| [200, {'Location' => '/v1.0/accounts/accountId/sites/1'}, '']}
      client.stubs.get('/v1.0/accounts/accountId/sites/1') {|env| [200, {}, Helper.xml['site']]}
      item = Site.create(client, data)
      expect(item[:id]).to eql(1)
    end
  end

  describe '#update' do
    it 'should update a site' do
      data = {:description => "test"}
      client.stubs.put('/v1.0/accounts/accountId/sites/1', client.build_xml({:site => data})) {|env| [200, {}, '']}
      item = Site.new({:id => 1}, client)
      item.update(data)
    end
  end

  describe '#delete' do
    it 'should remove a site' do
      client.stubs.delete('/v1.0/accounts/accountId/sites/1') {|env| [200, {}, '']}
      item = Site.new({:id => 1}, client)
      item.delete()
    end
  end

  describe '#get_sip_peers' do
    it 'should return peers' do
      client.stubs.get('/v1.0/accounts/accountId/sites/1/sippeers') {|env| [200, {}, Helper.xml['sip_peers']]}
      site = Site.new({:id => 1}, client)
      list = site.get_sip_peers()
      expect(list.length).to eql(1)
      expect(list[0][:peer_id]).to eql(12345)
      expect(list[0][:peer_name]).to eql("SIP Peer 1")
      expect(list[0][:description]).to eql("Sip Peer 1 description")
    end
  end

  describe '#get_sip_peer' do
    it 'should return a peer' do
      client.stubs.get('/v1.0/accounts/accountId/sites/1/sippeers/11') {|env| [200, {}, Helper.xml['sip_peer']]}
      site = Site.new({:id => 1}, client)
      item = site.get_sip_peer(11)
      expect(item[:peer_id]).to eql(10)
      expect(item[:peer_name]).to eql("SIP Peer 1")
      expect(item[:description]).to eql("Sip Peer 1 description")
    end
  end

  describe '#create_sip_peer' do
    it 'should create a peer' do
      data = {:peer_name => "SIP Peer 1", :description => "Sip Peer 1 description"}
      client.stubs.post('/v1.0/accounts/accountId/sites/1/sippeers', client.build_xml({:sip_peer => data})) {|env| [201, {'Location' => '/v1.0/accounts/accountId/sites/1/sippeers/11'}, '']}
      client.stubs.get('/v1.0/accounts/accountId/sites/1/sippeers/11') {|env| [200, {}, Helper.xml['sip_peer']]}
      site = Site.new({:id => 1}, client)
      item = site.create_sip_peer(data)
      expect(item[:peer_id]).to eql(10)
      expect(item[:peer_name]).to eql("SIP Peer 1")
      expect(item[:description]).to eql("Sip Peer 1 description")
    end
  end
end
