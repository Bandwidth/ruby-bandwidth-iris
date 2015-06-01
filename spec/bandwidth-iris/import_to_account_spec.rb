describe BandwidthIris::ImportToAccount do
  client = nil

  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#get_notes' do
    it 'should return notes' do
      client.stubs.get('/v1.0/accounts/accountId/importToAccounts/1/notes') {|env| [200, {}, Helper.xml['notes']]}
      order = ImportToAccount.new({:id => 1}, client)

      list = order.get_notes()
      expect(list[0][:id]).to eql(11299)
      expect(list[0][:user_id]).to eql('customer')
      expect(list[0][:description]).to eql('Test')
    end
  end

  describe '#add_notes' do
    it 'should add a note and return it' do
      data = {:user_id => 'customer', :description => 'Test'}
      client.stubs.post('/v1.0/accounts/accountId/importToAccounts/1/notes', client.build_xml({note: data})) {|env| [200, {:location => '/v1.0/accounts/FakeAccountId/importToAccounts/1/notes/11299'}, '']}
      client.stubs.get('/v1.0/accounts/accountId/importToAccounts/1/notes') {|env| [200, {}, Helper.xml['notes']]}
      order = ImportToAccount.new({:id => 1}, client)
      item = order.add_notes(data)
      expect(item[:id]).to eql(11299)
      expect(item[:user_id]).to eql('customer')
      expect(item[:description]).to eql('Test')
    end
  end
end
