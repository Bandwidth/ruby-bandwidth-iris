describe BandwidthIris::Lidb do
  client = nil

  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#list' do
    it 'should return orders' do
      client.stubs.get('/v1.0/accounts/accountId/lidbs') {|env| [200, {}, Helper.xml['lidbs']]}
      Lidb.list(client)
    end
  end

  describe '#get' do
    it 'should return an order' do
      client.stubs.get('/v1.0/accounts/accountId/lidbs/1') {|env| [200, {}, Helper.xml['lidb']]}
      Lidb.get(client, 1)
    end
  end

  describe '#create' do
    it 'should create a subscription' do
      data = {
        :customer_order_id =>"A Test order",
        :lidb_tn_groups => {
          :lidb_tn_group => {
            :telephone_numbers => ["8048030097", "8045030098"],
            :subscriber_information =>"Joes Grarage",
            :use_type => "RESIDENTIAL",
            :visibility => "PUBLIC"
          }
        }
      }
      client.stubs.post('/v1.0/accounts/accountId/lidbs', client.build_xml({:lidb_order => data})) {|env| [201, {'Location' => '/v1.0/accounts/accountId/lidbs/1'}, '']}
      client.stubs.get('/v1.0/accounts/accountId/lidbs/1') {|env| [200, {}, Helper.xml['lidb']]}
      Lidb.create(client, data)
    end
  end
end
