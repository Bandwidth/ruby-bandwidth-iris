describe BandwidthIris::Account do
  client = nil

  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#get' do
    it 'should return an account' do
      client.stubs.get('/v1.0/accounts/accountId') {|env| [200, {}, Helper.xml['account']]}
      item = Account.get(client)
      expect(item[:account_id]).to eql(14)
    end
  end
end
