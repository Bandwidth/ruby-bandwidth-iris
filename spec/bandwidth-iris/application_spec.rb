describe BandwidthIris::Applications do
  client = nil

  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#get' do
    it 'should get applications' do
      client.stubs.get("/v1.0/accounts/accountId/applications", ){|env| [200, {},  Helper.xml['applicationList']]}
      application = Applications.get_applications(client)[0]
      expect(application[:application_list][:application][0][:application_id]).to eql("d1")
      expect(application[:application_list][:application][1][:application_id]).to eql("d2")
    end

    it 'should get an application' do
      client.stubs.get("/v1.0/accounts/accountId/applications/id", ){|env| [200, {},  Helper.xml['application']]}
      application = Applications.get_application(client, "id")[0]
      expect(application[:application][:application_id]).to eql("d1")
    end

    it 'should get an application\'s sippeers' do
      client.stubs.get("/v1.0/accounts/accountId/applications/id/associatedsippeers", ){|env| [200, {},  Helper.xml['applicationSippeers']]}
      sippeers = Applications.get_application_sippeers(client, "id")[0]
      expect(sippeers[:associated_sip_peers][:associated_sip_peer][0][:site_id]).to eql(1)
      expect(sippeers[:associated_sip_peers][:associated_sip_peer][1][:site_id]).to eql(2)
    end
  end

  describe '#create' do
    it' should create an application' do
      data = {
        :service_type => "Messaging-V2",
        :app_name => "Name",
        :msg_callback_url => "https://test.com"
      }
      client.stubs.post("/v1.0/accounts/accountId/applications", client.build_xml({:application => data})){|env| [200, {},  Helper.xml['application']]}
      application = Applications.create_application(client, data)[0]
      expect(application[:application][:application_id]).to eql("d1")
    end
  end

  describe '#update' do
    it 'should partial update an application' do
      data = {
        :service_type => "Messaging-V2",
        :app_name => "Name",
        :msg_callback_url => "https://test.com"
      }
      client.stubs.patch("/v1.0/accounts/accountId/applications/id", client.build_xml({:application => data})){|env| [200, {},  Helper.xml['application']]}
      application = Applications.partial_update_application(client, "id", data)[0]
      expect(application[:application][:application_id]).to eql("d1")
    end

    it 'should complete update an application' do
      data = {
        :service_type => "Messaging-V2",
        :app_name => "Name",
        :msg_callback_url => "https://test.com"
      }
      client.stubs.put("/v1.0/accounts/accountId/applications/id", client.build_xml({:application => data})){|env| [200, {},  Helper.xml['application']]}
      application = Applications.complete_update_application(client, "id", data)[0]
      expect(application[:application][:application_id]).to eql("d1")
    end
  end

  describe '#delete' do
    it 'should delete an application' do
      client.stubs.delete("/v1.0/accounts/accountId/applications/id"){|env| [200, {}, '']}
      Applications.delete_application(client, "id")
    end
  end

end
