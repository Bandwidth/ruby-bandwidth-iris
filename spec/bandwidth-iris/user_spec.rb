describe BandwidthIris::User do
  client = nil

  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#list' do
    it 'should return users' do
      client.stubs.get('/v1.0/users') {|env| [200, {}, Helper.xml['users']]}
      list = User.list(client)
      expect(list.length).to eql(2)
      expect(list[0][:username]).to eql('testcustomer')
    end
  end

end
