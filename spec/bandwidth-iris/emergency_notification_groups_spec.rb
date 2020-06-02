describe BandwidthIris::EmergencyNotificationGroups do
  client = nil

  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#EngOrderTests' do
    it 'should create eng order' do
      data = {
          :value => "value"
      }
      client.stubs.post("/v1.0/accounts/accountId/emergencyNotificationGroupOrders", client.build_xml({:emergency_notification_group_order => data})) {|env| [200, {}, Helper.xml['emergencyNotificationGroupOrder']]}
      order = EmergencyNotificationGroups.create_emergency_notification_group_order(client, data)
      puts order
    end

    it 'should get eng orders' do
      client.stubs.get("/v1.0/accounts/accountId/emergencyNotificationGroupOrders") {|env| [200, {}, Helper.xml['emergencyNotificationGroupOrders']]}
      orders = EmergencyNotificationGroups.get_emergency_notification_group_orders(client)
      puts orders
    end

    it 'should get eng order' do
      client.stubs.get("/v1.0/accounts/accountId/emergencyNotificationGroupOrders/id") {|env| [200, {}, Helper.xml['emergencyNotificationGroupOrder']]}
      order = EmergencyNotificationGroups.get_emergency_notification_group_order(client, "id")
      puts order
    end
  end

  describe '#EngTests' do
    it 'should get eng' do
      client.stubs.get("/v1.0/accounts/accountId/emergencyNotificationGroups/id") {|env| [200, {}, Helper.xml['emergencyNotificationGroup']]}
      eng = EmergencyNotificationGroups.get_emergency_notification_group(client, "id")
      puts eng
    end

    it 'should get engs' do
      client.stubs.get("/v1.0/accounts/accountId/emergencyNotificationGroups") {|env| [200, {}, Helper.xml['emergencyNotificationGroups']]}
      engs = EmergencyNotificationGroups.get_emergency_notification_groups(client)
      puts engs
    end
  end
end
