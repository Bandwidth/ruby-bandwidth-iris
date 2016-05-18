describe BandwidthIris::LnpChecker do
  client = nil

  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#check' do
    it 'should check numbers' do
      numbers = ['1111', '2222']
      data = {:number_portability_request => {:tn_list => {:tn => numbers}}}
      client.stubs.post('/v1.0/accounts/accountId/lnpchecker?fullCheck=true', client.build_xml(data)) {|env| [200, {}, Helper.xml['lnp_check']]}
      result = LnpChecker.check(client, numbers, true)
      expect(result[:supported_rate_centers][:rate_center_group][:rate_center]).to eql("Center1")
      expect(result[:supported_rate_centers][:rate_center_group][:city]).to eql("City1")
      expect(result[:supported_rate_centers][:rate_center_group][:state]).to eql("State1")
    end

    it 'should allow to use 1 number as string' do
      number = '1111'
      data = {:number_portability_request => {:tn_list => {:tn => number}}}
      client.stubs.post('/v1.0/accounts/accountId/lnpchecker?fullCheck=true', client.build_xml(data)) {|env| [200, {}, Helper.xml['lnp_check']]}
      result = LnpChecker.check(client, number, true)
      expect(result[:supported_rate_centers][:rate_center_group][:rate_center]).to eql("Center1")
      expect(result[:supported_rate_centers][:rate_center_group][:city]).to eql("City1")
      expect(result[:supported_rate_centers][:rate_center_group][:state]).to eql("State1")
    end
  end

end
