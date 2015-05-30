describe BandwidthIris::Client do
  describe '#initialize' do
    it 'should create instance of Client' do
      expect(Client.new()).to be_a(Client)
      expect(Client.new('accountId', 'user', 'password')).to be_a(Client)
      expect(Client.new('accountId', 'user', 'password', {})).to be_a(Client)
      expect(Client.new({:account_id => 'accountId', :username => 'user', :password => 'password'})).to be_a(Client)
    end
  end

  describe '#global_options' do
    it 'should return and change @@global_options of Client' do
      Client.global_options = {:account_id => 'accountId', :username => 'username', :password => 'password'}
      expect(Client.global_options).to eql({:account_id => 'accountId', :username => 'username', :password => 'password'})
    end
  end

  describe '#get_id_from_location_header' do
    it 'should return last url path item as id' do
      expect(Client.get_id_from_location_header('http://localhost/path1/path2/id')).to eql('id')
    end
    it 'should raise error if location is missing or nil' do
      expect{Client.get_id_from_location_header('')}.to raise_error
      expect{Client.get_id_from_location_header(nil)}.to raise_error
    end
  end

  describe '#concat_account_path' do
    client = nil
    before :each do
      client = Helper.get_client()
    end

    it 'should add user id to path' do
      expect(client.concat_account_path('test')).to eql('/accounts/accountId/test')
      expect(client.concat_account_path('/test1')).to eql('/accounts/accountId/test1')
    end
  end

  describe '#create_connection' do
    client = nil
    before :each do
      client = Helper.get_client()
    end

    it 'should create new faraday connection' do
      connection = client.create_connection()
      expect(connection).to be_a(Faraday::Connection)
      expect(connection.headers['Authorization']).to eql("Basic #{Base64.strict_encode64('username:password')}")
    end
  end

  describe '#make_request' do
    client = nil
    before :each do
      client = Helper.get_client()
    end

    after :each do
      client.stubs.verify_stubbed_calls()
    end

    it 'should make GET request and return xml  data' do
      client.stubs.get('/v1.0/path1') { |env| [200, {}, '<Result><Test>data</Test></Result>'] }
      client.stubs.get('/v1.0/path2?testField=10') { |env| [200, {'Location'=>'url'}, '<Root><TestValue>10</TestValue><DataArray>1</DataArray><DataArray>2</DataArray><BoolValue>true</BoolValue><BoolValue2>false</BoolValue2><DateTimeValue>2015-05-29T01:02:03Z</DateTimeValue></Root>'] }
      expect(client.make_request(:get, '/path1')).to eql([{:test => 'data'}, {}])
      expect(client.make_request(:get, '/path2', {:test_field => 10})).to eql([{:test_value => 10, :data_array => [1, 2], :bool_value => true, :bool_value2 => false, :date_time_value => DateTime.new(2015,5,29,1,2,3)}, {:location=>'url'}])
    end

    it 'should make POST request and return xml data' do
      client.stubs.post('/v1.0/path1', '<?xml version="1.0" encoding="UTF-8"?><Request><TestField1>test</TestField1><TestField2>10</TestField2><TestField3>false</TestField3><TestFieldd4>2015-05-29T01:02:03+00:00</TestFieldd4></Request>')  { |env|  [200, {}, '<Response><Success>true</Success></Response>'] }
      expect(client.make_request(:post, '/path1', {:request => {:test_field1 => "test", :test_field2 => 10, :test_field3 => false, :test_fieldd4 => DateTime.new(2015, 5, 29, 1,2,3)}})[0]).to eql(:success => true)
    end

    it 'should make PUT request and return xml data' do
      client.stubs.put('/v1.0/path1', '<?xml version="1.0" encoding="UTF-8"?><Request><TestField1>test</TestField1></Request>')  { |env|  [200, {}, '<Response><Success>true</Success></Response>'] }
      expect(client.make_request(:put, '/path1', {:request => {:test_field1 => "test"}})[0]).to eql(:success => true)
    end

    it 'should make DELETE request and return xml  data' do
      client.stubs.delete('/v1.0/path1') { |env| [200, {}, '<Result><Test>data</Test></Result>'] }
      expect(client.make_request(:delete, '/path1')).to eql([{:test => 'data'}, {}])
    end

    it 'should raise error if http status >= 400' do
      client.stubs.get('/v1.0/path1') { |env| [400, {}, ''] }
      expect{client.make_request(:get, '/path1')}.to raise_error(Errors::GenericError, "Http code 400")
    end

    it 'should fail if output contains ErrorCode and Description' do
      client.stubs.get('/v1.0/path1') { |env| [200, {}, '<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><Response><Test><ErrorCode>400</ErrorCode><Description>Error</Description></Test></Response>'] }
      expect{client.make_request(:get, '/path1')}.to raise_error(Errors::GenericError, "Error")
    end

    it 'should fail if output contains element Error with Code and Description' do
      client.stubs.get('/v1.0/path1') { |env| [200, {}, '<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><Response><Test><Error><Code>400</Code><Description>Error</Description></Error></Test></Response>'] }
      expect{client.make_request(:get, '/path1')}.to raise_error(Errors::GenericError, "Error")
    end

    it 'should fail if output contains elements Errors with Code and Description' do
      client.stubs.get('/v1.0/path1') { |env| [200, {}, '<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><Response><Test><Errors><Code>400</Code><Description>Error</Description></Errors><Errors><Code>401</Code><Description>Error1</Description></Errors></Test></Response>'] }
      expect{client.make_request(:get, '/path1')}.to raise_error(Errors::AgregateError)
    end

    it 'should fail if output contains elements Errors with Code and Description (for 1 element)' do
      client.stubs.get('/v1.0/path1') { |env| [200, {}, '<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><Response><Test><Errors><Code>400</Code><Description>Error</Description></Errors></Test></Response>'] }
      expect{client.make_request(:get, '/path1')}.to raise_error(Errors::AgregateError)
    end

    it 'should fail if output contains elements resultCode and resultMessage' do
      client.stubs.get('/v1.0/path1') { |env| [200, {}, '<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><Response><Test><resultCode>400</resultCode><resultMessage>Error</resultMessage></Test></Response>'] }
      expect{client.make_request(:get, '/path1')}.to raise_error(Errors::GenericError, "Error")
    end

    it 'should fail if output contains elements resultCode and resultMessage (more deep)' do
      client.stubs.get('/v1.0/path1') { |env| [200, {}, '<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><Response><Tests><Test></Test><Test><resultCode>400</resultCode><resultMessage>Error</resultMessage></Test></Tests></Response>'] }
      expect{client.make_request(:get, '/path1')}.to raise_error(Errors::GenericError, "Error")
    end

    it 'should not fail if resultCode == 0' do
      client.stubs.get('/v1.0/path1') { |env| [200, {}, '<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><Response><Test><resultCode>0</resultCode><resultMessage>Completed</resultMessage></Test></Response>'] }
     client.make_request(:get, '/path1')
    end
  end
end
