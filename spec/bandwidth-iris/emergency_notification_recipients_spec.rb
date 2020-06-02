describe BandwidthIris::EmergencyNotificationRecipients do
  client = nil

  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#EnrTests' do
    it 'should create enr' do
      data = {
          :value => "value"
      }
      client.stubs.post("/v1.0/accounts/accountId/emergencyNotificationRecipients", client.build_xml({:emergency_notification_recipient => data})) {|env| [200, {}, Helper.xml['emergencyNotificationRecipient']]}
      enr = EmergencyNotificationRecipients.create_emergency_notification_recipient(client, data)
      expect(enr[:identifier]).to eql(" 63865500-0904-46b1-9b4f-7bd237a26363 ")
    end

    it 'should get enrs' do
      client.stubs.get("/v1.0/accounts/accountId/emergencyNotificationRecipients") {|env| [200, {}, Helper.xml['emergencyNotificationRecipients']]}
      enrs = EmergencyNotificationRecipients.get_emergency_notification_recipients(client)
      expect(enrs[:emergency_notification_recipients][:emergency_notification_recipient][0][:identifier]).to eql(" 63865500-0904-46b1-9b4f-7bd237a26363 ")
    end

    it 'should get enr' do
      client.stubs.get("/v1.0/accounts/accountId/emergencyNotificationRecipients/id") {|env| [200, {}, Helper.xml['emergencyNotificationRecipient']]}
      enr = EmergencyNotificationRecipients.get_emergency_notification_recipient(client, "id")
      expect(enr[:identifier]).to eql(" 63865500-0904-46b1-9b4f-7bd237a26363 ")
    end

    it 'should replace enr' do
      data = {
          :value => "value"
      }
      client.stubs.put("/v1.0/accounts/accountId/emergencyNotificationRecipients/id", client.build_xml({:emergency_notification_recipient => data})) {|env| [200, {}, Helper.xml['emergencyNotificationRecipient']]}
      enr = EmergencyNotificationRecipients.replace_emergency_notification_recipient(client, "id", data)
      expect(enr[:identifier]).to eql(" 63865500-0904-46b1-9b4f-7bd237a26363 ")
    end

    it 'should delete enr' do
      client.stubs.delete("/v1.0/accounts/accountId/emergencyNotificationRecipients/id") {|env| [200, {}, '']}
      EmergencyNotificationRecipients.delete_emergency_notification_recipient(client, "id")
    end
  end
end
