describe BandwidthIris::AlternateEndUserIdentity do
  client = nil

  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#aeui' do
    it 'should get aeuis' do
      client.stubs.get("/v1.0/accounts/accountId/aeuis") {|env| [200, {}, Helper.xml['aeuis']]}
      aeuis = AlternateEndUserIdentity.get_alternate_end_user_information(client)
      expect(aeuis[:alternate_end_user_identifiers][:alternate_end_user_identifier][0][:identifier]).to eql("DavidAcid")
    end

    it 'should get aeui' do
      client.stubs.get("/v1.0/accounts/accountId/aeuis/id") {|env| [200, {}, Helper.xml['aeui']]}
      aeui = AlternateEndUserIdentity.get_alternate_caller_information(client, "id")
      expect(aeui[:identifier]).to eql("DavidAcid")
    end
  end
end
