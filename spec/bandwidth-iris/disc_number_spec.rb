describe BandwidthIris::DiscNumber do
  client = nil

  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#list' do
    it 'should return numbers' do
      client.stubs.get('/v1.0/accounts/accountId/discnumbers') {|env| [200, {}, '<Response><TelephoneNumbers></TelephoneNumbers></Response>']}
      DiscNumber.list(client)
    end
  end

  describe '#totals' do
    it 'should return totals' do
      client.stubs.get('/v1.0/accounts/accountId/discnumbers/totals') {|env| [200, {}, '<Response></Response>']}
      DiscNumber.totals(client)
    end
  end
end
