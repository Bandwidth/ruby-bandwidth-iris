describe BandwidthIris::EmergencyNotificationEndpoints do
  client = nil

  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#EneTests' do
    it 'should create ene order' do
      data = {
          :value => "value"
      }
      client.stubs.post("/v1.0/accounts/accountId/emergencyNotificationEndpointOrders", client.build_xml({:emergency_notification_endpoint_order => data})) {|env| [200, {}, Helper.xml['emergencyNotificationEndpointOrder']]}
      ene_order = EmergencyNotificationEndpoints.create_emergency_notification_endpoint_order(client, data)
      puts ene_order
    end

    it 'should get ene orders' do
      client.stubs.get("/v1.0/accounts/accountId/emergencyNotificationEndpointOrders") {|env| [200, {}, Helper.xml['emergencyNotificationEndpointOrders']]}
      ene_orders = EmergencyNotificationEndpoints.get_emergency_notification_endpoint_orders(client)
      puts ene_orders
    end

    it 'should get ene order' do
      client.stubs.get("/v1.0/accounts/accountId/emergencyNotificationEndpointOrders/id") {|env| [200, {}, Helper.xml['emergencyNotificationEndpointOrder']]}
      ene_order = EmergencyNotificationEndpoints.get_emergency_notification_endpoint_order(client, "id")
      puts ene_order
    end
  end
end

