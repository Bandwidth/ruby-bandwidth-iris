describe BandwidthIris::SipPeerProducts do
  client = nil

  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#originationSettings' do
    it 'should get origination settings' do
      client.stubs.get("/v1.0/accounts/accountId/sites/siteId/sippeers/sippeerId/products/origination/settings"){|env| [200, {},  Helper.xml['sippeerOriginationSettings']]}
      settings = SipPeerProducts.get_origination_settings(client, "siteId", "sippeerId")
      expect(settings[:voice_protocol]).to eql("HTTP")
    end
    it 'should create origination settings' do
      data = {
        :voice_protocol => "HTTP"
      }
      client.stubs.post("/v1.0/accounts/accountId/sites/siteId/sippeers/sippeerId/products/origination/settings", client.build_xml({:sip_peer_origination_settings => data})){|env| [200, {},  Helper.xml['sippeerOriginationSettings']]}
      settings = SipPeerProducts.create_origination_settings(client, "siteId", "sippeerId", data)
      expect(settings[:voice_protocol]).to eql("HTTP")
    end
    it 'should update origination settings' do
      data = {
        :voice_protocol => "HTTP"
      }
      client.stubs.put("/v1.0/accounts/accountId/sites/siteId/sippeers/sippeerId/products/origination/settings", client.build_xml({:sip_peer_origination_settings => data})){|env| [200, {},  Helper.xml['sippeerOriginationSettings']]}
      SipPeerProducts.update_origination_settings(client, "siteId", "sippeerId", data)
    end
  end

  describe '#terminationSettings' do
    it 'should get termination settings' do
      client.stubs.get("/v1.0/accounts/accountId/sites/siteId/sippeers/sippeerId/products/termination/settings"){|env| [200, {},  Helper.xml['sippeerTerminationSettings']]}
      settings = SipPeerProducts.get_termination_settings(client, "siteId", "sippeerId")
      expect(settings[:voice_protocol]).to eql("HTTP")
    end
    it 'should create termination settings' do
      data = {
        :voice_protocol => "HTTP"
      }
      client.stubs.post("/v1.0/accounts/accountId/sites/siteId/sippeers/sippeerId/products/termination/settings", client.build_xml({:sip_peer_termination_settings => data})){|env| [200, {},  Helper.xml['sippeerTerminationSettings']]}
      settings = SipPeerProducts.create_termination_settings(client, "siteId", "sippeerId", data)
      expect(settings[:voice_protocol]).to eql("HTTP")
    end
    it 'should update termination settings' do
      data = {
        :voice_protocol => "HTTP"
      }
      client.stubs.put("/v1.0/accounts/accountId/sites/siteId/sippeers/sippeerId/products/termination/settings", client.build_xml({:sip_peer_termination_settings => data})){|env| [200, {},  Helper.xml['sippeerTerminationSettings']]}
      SipPeerProducts.update_termination_settings(client, "siteId", "sippeerId", data)
    end
  end

  describe '#smsFeatureSettings' do
    it 'should get sms feature settings' do
      client.stubs.get("/v1.0/accounts/accountId/sites/siteId/sippeers/sippeerId/products/messaging/features/sms"){|env| [200, {},  Helper.xml['sippeerSmsFeature']]}
      settings = SipPeerProducts.get_sms_feature_settings(client, "siteId", "sippeerId")
      expect(settings[:sip_peer_sms_feature_settings][:toll_free]).to eql(true)
    end
    it 'should create sms feature settings' do
      data = {
        :sip_peer_sms_feature_settings => {
          :toll_free => true
        }
      }
      client.stubs.post("/v1.0/accounts/accountId/sites/siteId/sippeers/sippeerId/products/messaging/features/sms", client.build_xml({:sip_peer_sms_feature => data})){|env| [200, {},  Helper.xml['sippeerSmsFeature']]}
      settings = SipPeerProducts.create_sms_feature_settings(client, "siteId", "sippeerId", data)
      expect(settings[:sip_peer_sms_feature_settings][:toll_free]).to eql(true)
    end
    it 'should update sms feature settings' do
      data = {
        :sip_peer_sms_feature_settings => {
          :toll_free => true
        }
      }
      client.stubs.put("/v1.0/accounts/accountId/sites/siteId/sippeers/sippeerId/products/messaging/features/sms", client.build_xml({:sip_peer_sms_feature => data})){|env| [200, {},  Helper.xml['sippeerSmsFeature']]}
      settings = SipPeerProducts.update_sms_feature_settings(client, "siteId", "sippeerId", data)
      expect(settings[:sip_peer_sms_feature_settings][:toll_free]).to eql(true)
    end
    it 'should delete sms feature settings' do
      client.stubs.delete("/v1.0/accounts/accountId/sites/siteId/sippeers/sippeerId/products/messaging/features/sms"){|env| [200, {},  Helper.xml['sippeerSmsFeature']]}
      SipPeerProducts.delete_sms_feature_settings(client, "siteId", "sippeerId")
    end
  end

  describe '#mmsFeatureSettings' do
    it 'should get mms feature settings' do
      client.stubs.get("/v1.0/accounts/accountId/sites/siteId/sippeers/sippeerId/products/messaging/features/mms"){|env| [200, {},  Helper.xml['sippeerMmsFeature']]}
      settings = SipPeerProducts.get_mms_feature_settings(client, "siteId", "sippeerId")
      expect(settings[:mms_settings][:protocol]).to eql("MM4")
    end
    it 'should create mms feature settings' do
      data = {
        :mms_settings => {
          :protocol => "MM4"
        }
      }
      client.stubs.post("/v1.0/accounts/accountId/sites/siteId/sippeers/sippeerId/products/messaging/features/mms", client.build_xml({:mms_feature => data})){|env| [200, {},  Helper.xml['sippeerMmsFeature']]}
      settings = SipPeerProducts.create_mms_feature_settings(client, "siteId", "sippeerId", data)
      expect(settings[:mms_settings][:protocol]).to eql("MM4")
    end
    it 'should update mms feature settings' do
      data = {
        :mms_settings => {
          :protocol => "MM4"
        }
      }
      client.stubs.put("/v1.0/accounts/accountId/sites/siteId/sippeers/sippeerId/products/messaging/features/mms", client.build_xml({:mms_feature => data})){|env| [200, {},  Helper.xml['sippeerMmsFeature']]}
      SipPeerProducts.update_mms_feature_settings(client, "siteId", "sippeerId", data)
    end
    it 'should delete mms feature settings' do
      client.stubs.delete("/v1.0/accounts/accountId/sites/siteId/sippeers/sippeerId/products/messaging/features/mms"){|env| [200, {},  Helper.xml['sippeerMmsFeature']]}
      SipPeerProducts.delete_mms_feature_settings(client, "siteId", "sippeerId")
    end
  end

  describe '#mmsFeatureMmsSettings' do
    it 'should get mms feature mms settings' do
      client.stubs.get("/v1.0/accounts/accountId/sites/siteId/sippeers/sippeerId/products/messaging/features/mms/settings"){|env| [200, {},  Helper.xml['sippeerMmsFeatureMmsSettings']]}
      settings = SipPeerProducts.get_mms_feature_mms_settings(client, "siteId", "sippeerId")
      expect(settings[:protocol]).to eql("MM4")
    end
  end

  describe '#messagingApplicationSettings' do
    it 'should get messaging application settings' do
      client.stubs.get("/v1.0/accounts/accountId/sites/siteId/sippeers/sippeerId/products/messaging/applicationSettings"){|env| [200, {},  Helper.xml['messagingApplicationSettings']]}
      settings = SipPeerProducts.get_messaging_application_settings(client, "siteId", "sippeerId")
      expect(settings[:http_messaging_v2_app_id]).to eql("4a4ca6c1-156b-4fca-84e9-34e35e2afc32")
    end
    it 'should update messaging application settings' do
      data = {
        :http_messaging_v2_app_id => "4a4ca6c1-156b-4fca-84e9-34e35e2afc32"
      }
      client.stubs.put("/v1.0/accounts/accountId/sites/siteId/sippeers/sippeerId/products/messaging/applicationSettings", client.build_xml({:applications_settings => data})){|env| [200, {},  Helper.xml['messagingApplicationSettings']]}
      settings = SipPeerProducts.update_messaging_application_settings(client, "siteId", "sippeerId", data)
      expect(settings[:http_messaging_v2_app_id]).to eql("4a4ca6c1-156b-4fca-84e9-34e35e2afc32")
    end
  end

  describe '#messagingSettings' do
    it 'should get messaging settings' do
      client.stubs.get("/v1.0/accounts/accountId/sites/siteId/sippeers/sippeerId/products/messaging/settings"){|env| [200, {},  Helper.xml['sippeerMessageSettings']]}
      settings = SipPeerProducts.get_messaging_settings(client, "siteId", "sippeerId")
      expect(settings[:break_out_countries][:country]).to eql("CAN")
    end
    it 'should update messaging settings' do
      data = {
        :break_out_countries => {
          :country => "CAN"
        }
      }
      client.stubs.put("/v1.0/accounts/accountId/sites/siteId/sippeers/sippeerId/products/messaging/settings", client.build_xml({:sip_peer_messaging_settings => data})){|env| [200, {},  Helper.xml['sippeerMessageSettings']]}
      settings = SipPeerProducts.update_messaging_settings(client, "siteId", "sippeerId", data)
      expect(settings[:break_out_countries][:country]).to eql("CAN")
    end
  end
end
