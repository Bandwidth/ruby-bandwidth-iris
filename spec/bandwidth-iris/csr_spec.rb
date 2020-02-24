describe BandwidthIris::Csr do
  client = nil

  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#create' do
    it 'should create a csr' do
      data = {
        :customer_order_id => "123",
        :working_or_billing_telephone_number => "5554443333"
      }
      client.stubs.post("/v1.0/accounts/accountId/csrs", client.build_xml({:csr => data})) {|env| [200, {}, Helper.xml['csr']]}
      item = BandwidthIris::Csr.create(client, data)
      expect(item[0][:status]).to eql("RECEIVED")
    end
  end

  describe '#get' do
    it 'should get a csr' do
      client.stubs.get("/v1.0/accounts/accountId/csrs/123") {|env| [200, {}, Helper.xml['csr']]}
      item = BandwidthIris::Csr.get(client, "123")
      expect(item[0][:status]).to eql("RECEIVED")
    end
  end

  describe '#replace' do
    it 'should replace a csr' do
      data = {
        :customer_order_id => "123",
        :working_or_billing_telephone_number => "5554443333"
      }
      client.stubs.put("/v1.0/accounts/accountId/csrs/123", client.build_xml({:csr => data})) {|env| [200, {}, Helper.xml['csr']]}
      item = BandwidthIris::Csr.replace(client, "123", data)
      expect(item[0][:status]).to eql("RECEIVED")
    end
  end

  describe '#getnotes' do
    it 'should get csr notes' do
      client.stubs.get("/v1.0/accounts/accountId/csrs/123/notes") {|env| [200, {}, Helper.xml['notes']]}
      item = BandwidthIris::Csr.get_notes(client, "123")
      expect(item[0][:note][0][:id]).to eql(11299)
    end
  end

  describe '#addnote' do
    it 'should add csr note' do
      data = {
        :user_id => "id",
        :description => "description"
      }
      client.stubs.post("/v1.0/accounts/accountId/csrs/123/notes", client.build_xml({:note => data})) {|env| [200, {}, ""]}
      BandwidthIris::Csr.add_note(client, "123", data)
    end
  end

  describe '#updatenote' do
    it 'should update csr note' do
      data = {
        :user_id => "id",
        :description => "description"
      }
      client.stubs.put("/v1.0/accounts/accountId/csrs/123/notes/456", client.build_xml({:note => data})) {|env| [200, {}, ""]}
      BandwidthIris::Csr.update_note(client, "123", "456", data)
    end
  end
end
