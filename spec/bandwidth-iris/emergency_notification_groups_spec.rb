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
      expect(order[:order_id]).to eql("900b3646-18df-4626-b237-3a8de648ebf6")
    end

    it 'should get eng orders' do
      client.stubs.get("/v1.0/accounts/accountId/emergencyNotificationGroupOrders") {|env| [200, {}, Helper.xml['emergencyNotificationGroupOrders']]}
      orders = EmergencyNotificationGroups.get_emergency_notification_group_orders(client)
      expect(orders[:emergency_notification_group_orders][:emergency_notification_group_order][0][:order_id]).to eql("092815dc-9ced-4d67-a070-a80eb243b914")
    end

    it 'should get eng order' do
      client.stubs.get("/v1.0/accounts/accountId/emergencyNotificationGroupOrders/id") {|env| [200, {}, Helper.xml['emergencyNotificationGroupOrder']]}
      order = EmergencyNotificationGroups.get_emergency_notification_group_order(client, "id")
      expect(order[:order_id]).to eql("900b3646-18df-4626-b237-3a8de648ebf6")
    end
  end

  describe '#EngTests' do
    it 'should get eng' do
      client.stubs.get("/v1.0/accounts/accountId/emergencyNotificationGroups/id") {|env| [200, {}, Helper.xml['emergencyNotificationGroup']]}
      eng = EmergencyNotificationGroups.get_emergency_notification_group(client, "id")
      expect(eng[:identifier]).to eql("63865500-0904-46b1-9b4f-7bd237a26363") 
    end

    it 'should get engs' do
      client.stubs.get("/v1.0/accounts/accountId/emergencyNotificationGroups") {|env| [200, {}, Helper.xml['emergencyNotificationGroups']]}
      engs = EmergencyNotificationGroups.get_emergency_notification_groups(client)
      expect(engs[:emergency_notification_groups][:emergency_notification_group][0][:identifier]).to eql("63865500-0904-46b1-9b4f-7bd237a26363")
    end
  end
end
