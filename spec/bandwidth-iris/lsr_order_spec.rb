describe BandwidthIris::LsrOrder do
  client = nil

  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#create' do
    it 'should create an order' do
      data = {
        :pon =>"Some Pon",
        :customer_order_id => "MyId5",
        'sPID' => "123C",
        '_sPIDXmlElement' => 'sPID',
        :billing_telephone_number => "9192381468",
        :requested_foc_date => "2015-11-15",
        :authorizing_person => "Jim Hopkins",
        :subscriber => {
          :subscriber_type => "BUSINESS",
          :business_name => "BusinessName",
          :service_address =>  {
            :house_number =>"11",
            :street_name => "Park",
            :street_suffix => "Ave",
            :city => "New York",
            :state_code => "NY",
            :zip => "90025"
          },
          :account_number => "123463",
          :pin_number => "1231"
        },
        :list_of_telephone_numbers => {
          :telephone_number => ["9192381848", "9192381467"]
        }
      }
      client.stubs.post('/v1.0/accounts/accountId/lsrorders', client.build_xml({:lsr_order => data})) {|env| [200, {'Location' => '/v1.0/accounts/accountId/lsrorders/1'}, '']}
      client.stubs.get('/v1.0/accounts/accountId/lsrorders/1') {|env| [200, {}, Helper.xml['lsr_order']]}
      order = LsrOrder.create(client, data)
      expect(order[:id]).to eql("00cf7e08-cab0-4515-9a77-2d0a7da09415")
    end
  end

  describe '#get' do
    it 'should return an order' do
      client.stubs.get('/v1.0/accounts/accountId/lsrorders/1') {|env| [200, {}, Helper.xml['lsr_order']]}
      order = LsrOrder.get(client, "1")
      expect(order.account_id).to eql(9999999)
    end
  end

  describe '#list' do
    it 'should return orders' do
      client.stubs.get('/v1.0/accounts/accountId/lsrorders') {|env| [200, {}, Helper.xml['lsr_orders']]}
      list = LsrOrder.list(client)
      expect(list.length).to eql(2)
    end
  end

  describe '#update' do
    it 'should update an order' do
      data = { :name => "Test",  :close_order => true }
      client.stubs.put('/v1.0/accounts/accountId/lsrorders/1', client.build_xml({:lsr_order => data})) {|env| [200, {}, '']}
      item = LsrOrder.new({:id => 1}, client)
      item.update(data)
    end
  end

  describe '#get_notes' do
    it 'should return notes' do
      client.stubs.get('/v1.0/accounts/accountId/lsrorders/1/notes') {|env| [200, {}, Helper.xml['notes']]}
      order = LsrOrder.new({:id => 1}, client)

      list = order.get_notes()
      expect(list[0][:id]).to eql(11299)
      expect(list[0][:user_id]).to eql('customer')
      expect(list[0][:description]).to eql('Test')
    end
  end

  describe '#add_notes' do
    it 'should add a note and return it' do
      data = {:user_id => 'customer', :description => 'Test'}
      client.stubs.post('/v1.0/accounts/accountId/lsrorders/1/notes', client.build_xml({note: data})) {|env| [200, {:location => '/v1.0/accounts/accountId/lsrorders/1/notes/11299'}, '']}
      client.stubs.get('/v1.0/accounts/accountId/lsrorders/1/notes') {|env| [200, {}, Helper.xml['notes']]}
      order = LsrOrder.new({:id => 1}, client)
      item = order.add_notes(data)
      expect(item[:id]).to eql(11299)
      expect(item[:user_id]).to eql('customer')
      expect(item[:description]).to eql('Test')
    end
  end
end
