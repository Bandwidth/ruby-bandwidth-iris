describe BandwidthIris::SipCredential do
  client = nil

  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#list' do
    it 'should return sip credentials' do
      client.stubs.get('/v1.0/accounts/accountId/sipcredentials') {|env| [200, {}, Helper.xml['sip_credentials']]}
      list = SipCredential.list(client)
      expect(list.length).to eql(1)
      expect(list[0][:user_name]).to eql(1)
    end
  end

  describe '#get' do
    it 'should return a sip credential' do
      client.stubs.get('/v1.0/accounts/accountId/sipcredentials/1') {|env| [200, {}, Helper.xml['sip_credentials']]}
      item = SipCredential.get(client, 1)
      expect(item[:user_name]).to eql(1)
    end
  end

  describe '#create' do
    it 'should create a sip credential' do
      data = {:name => "test", :description => "test"}
      client.stubs.post('/v1.0/accounts/accountId/sipcredentials', client.build_xml({:sip_credentials => { sip_credential: data }})) {|env| [200, {}, Helper.xml['valid_sip_credentials']]}
      item = SipCredential.create(client, data)
      expect(item[:user_name]).to eql(1)
    end
  end

  describe '#update' do
    it 'should update a sip credential' do
      data = {:hash1 => "1g32gadgs433dd4"}
      client.stubs.put('/v1.0/accounts/accountId/sipcredentials/1', client.build_xml({:sip_credential => data})) {|env| [200, {}, '']}
      item = SipCredential.new({:user_name => 1}, client)
      item.update(data)
    end
  end

  describe '#delete' do
    it 'should remove a sip credential' do
      client.stubs.delete('/v1.0/accounts/accountId/sipcredentials/1') {|env| [200, {}, '']}
      item = SipCredential.new({:user_name => 1}, client)
      item.delete
    end
  end
end
