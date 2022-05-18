describe BandwidthIris::PortIn do
  client = nil

  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#list_orders' do
    it 'should list port in orders' do
      client.stubs.get('/v1.0/accounts/accountId/portins') {|env| [200, {}, Helper.xml['port_ins']]}
      orders = PortIn.list(client)
      orders.each do |order|
        expect(order.class).to eql(BandwidthIris::PortIn)
      end
      expect(orders[0][:order_id]).to eql("ab03375f-e0a9-47f8-bd31-6d8435454a6b")
      expect(orders[1][:order_id]).to eql("b2190bcc-0272-4a51-ba56-7c3d628e8706")
      expect(orders[0][:lnp_losing_carrier_id]).to eql(1163)
      expect(orders[1][:lnp_losing_carrier_id]).to eql(1290)
      expect(orders[0][:last_modified_date]).to eql(DateTime.new(2020, 1, 15, 19, 8, 57.626))
      expect(orders[1][:last_modified_date]).to eql(DateTime.new(2020, 1, 15, 19, 6, 10.085))
    end
  end
  
  describe '#create' do
    it 'should create an order' do
      data = {
        :billing_telephone_number => "1111",
        :subscriber => {
          :subscriber_type => "BUSINESS",
          :business_name => "Company",
          :service_address => {
            :city => "City",
            :country => "Country"
          }
        }
      }
      client.stubs.post('/v1.0/accounts/accountId/portins', client.build_xml({:lnp_order => data})) {|env| [200, {}, Helper.xml['port_in']]}
      item = PortIn.create(client, data)
      expect(item[:id]).to eql("d28b36f7-fa96-49eb-9556-a40fca49f7c6")
      expect(item[:billing_type]).to eql('PORTIN')
    end
  end

  describe '#update' do
    it 'should update an order' do
      data = {
        :requested_foc_date => "2014-11-18T00:00:00.000Z",
        :wireless_info => {
          :account_number => "77129766500001",
          :pin_number => "0000"
        }
      }
      client.stubs.put('/v1.0/accounts/accountId/portins/1', client.build_xml({:lnp_order_supp => data})) {|env| [200, {}, '']}
      item = PortIn.new({:id => 1}, client)
      item.update(data)
    end
  end

  describe '#delete' do
    it 'should remove an order' do
      client.stubs.delete('/v1.0/accounts/accountId/portins/1') {|env| [200, {}, '']}
      item = PortIn.new({:id => 1}, client)
      item.delete()
    end
  end


  describe '#get_notes' do
    it 'should return notes' do
      client.stubs.get('/v1.0/accounts/accountId/portins/1/notes') {|env| [200, {}, Helper.xml['notes']]}
      order = PortIn.new({:id => 1}, client)

      list = order.get_notes()
      expect(list[0][:id]).to eql(11299)
      expect(list[0][:user_id]).to eql('customer')
      expect(list[0][:description]).to eql('Test')
    end
  end

  describe '#add_notes' do
    it 'should add a note and return it' do
      data = {:user_id => 'customer', :description => 'Test'}
      client.stubs.post('/v1.0/accounts/accountId/portins/1/notes', client.build_xml({note: data})) {|env| [200, {:location => '/v1.0/accounts/accountId/portins/1/notes/11299'}, '']}
      client.stubs.get('/v1.0/accounts/accountId/portins/1/notes') {|env| [200, {}, Helper.xml['notes']]}
      order = PortIn.new({:id => 1}, client)
      item = order.add_notes(data)
      expect(item[:id]).to eql(11299)
      expect(item[:user_id]).to eql('customer')
      expect(item[:description]).to eql('Test')
    end
  end

  describe '#get_files' do
    it 'should return list of files' do
      client.stubs.get('/v1.0/accounts/accountId/portins/1/loas?metadata=true') {|env| [200, {}, Helper.xml['files']]}
      item = PortIn.new({:id => 1}, client)
      list = item.get_files(true)
      expect(list.length).to eql(6)
      expect(list[0][:file_name]).to eql("d28b36f7-fa96-49eb-9556-a40fca49f7c6-1416231534986.txt")
    end
    it 'should return list of files (without metadata)' do
      client.stubs.get('/v1.0/accounts/accountId/portins/1/loas?metadata=false') {|env| [200, {}, Helper.xml['files']]}
      item = PortIn.new({:id => 1}, client)
      list = item.get_files()
      expect(list.length).to eql(6)
      expect(list[0][:file_name]).to eql("d28b36f7-fa96-49eb-9556-a40fca49f7c6-1416231534986.txt")
    end
  end

  describe '#get_file_metadata' do
    it 'should return metadata of a file' do
      client.stubs.get('/v1.0/accounts/accountId/portins/1/loas/file.txt/metadata') {|env| [200, {}, Helper.xml['file_metadata']]}
      item = PortIn.new({:id => 1}, client)
      meta = item.get_file_metadata('file.txt')
      expect(meta[:document_type]).to eql("LOA")
    end
  end

  describe '#get_file' do
    it 'should return file context and media type' do
      client.stubs.get('/v1.0/accounts/accountId/portins/1/loas/file.txt') {|env| [200, {'Content-Type' => 'text/plain'}, '123']}
      item = PortIn.new({:id => 1}, client)
      r = item.get_file('file.txt')
      expect(r[0]).to eql("123")
      expect(r[1]).to eql("text/plain")
    end
    it 'should return file context and media type (if media type is missing)' do
      client.stubs.get('/v1.0/accounts/accountId/portins/1/loas/file.txt') {|env| [200, {}, '123']}
      item = PortIn.new({:id => 1}, client)
      r = item.get_file('file.txt')
      expect(r[0]).to eql("123")
      expect(r[1]).to eql("application/octet-stream")
    end
  end

  describe '#create_file' do
    it 'should upload file context' do
      client.stubs.post('/v1.0/accounts/accountId/portins/1/loas', '123', {'Content-Type' => 'text/plain', 'Content-Length' => '3'}) {|env| [200, {}, Helper.xml['file_created']]}
      client.stubs.post('/v1.0/accounts/accountId/portins/1/loas', '123', {'Content-Type' => 'application/octet-stream', 'Content-Length' => '3'}) {|env| [200, {}, Helper.xml['file_created']]}
      item = PortIn.new({:id => 1}, client)
      r = item.create_file(StringIO.new('123'), 'text/plain')
      expect(r).to eql("test.txt")
      r = item.create_file(StringIO.new('123'))
      expect(r).to eql("test.txt")
    end
  end
end
