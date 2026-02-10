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
      expect{Client.get_id_from_location_header('')}.to raise_error(StandardError)
      expect{Client.get_id_from_location_header(nil)}.to raise_error(StandardError)
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
    end
  end

  describe '#make_request' do
    client = nil
    token_client = nil
    expired_token_client = nil
    client_credentials_client = nil

    before :each do
      client = Helper.get_client()
      token_client = Helper.get_token_client()
      expired_token_client = Helper.get_expired_token_client()
      client_credentials_client = Helper.get_client_credentials_client()
    end

    after :each do
      client.stubs.verify_stubbed_calls()
      token_client.stubs.verify_stubbed_calls()
      expired_token_client.stubs.verify_stubbed_calls()
      client_credentials_client.stubs.verify_stubbed_calls()
    end

    it 'should pass basic auth headers' do
      # Note: This endpoint does not exist. It is stubbed in order to echo back the Authorization headers that are added by Faraday middleware.
      client.stubs.get('/v1.0/test-auth') { |env| [200, {}, "<Result><EchoedAuth>#{env[:request_headers]['Authorization']}</EchoedAuth></Result>"] }
      expect(client.make_request(:get, '/test-auth')).to eql([{:echoed_auth=>"Basic #{Base64.strict_encode64('username:password')}"}, {}])
    end

    it 'should pass bearer auth header using token' do
      token_client.stubs.get('/v1.0/test-auth-token') { |env| [200, {}, "<Result><EchoedAuth>#{env[:request_headers]['Authorization']}</EchoedAuth></Result>"] }
      expect(token_client.make_request(:get, '/test-auth-token')).to eql([{:echoed_auth=>"Bearer accessToken"}, {}])
      expect(token_client.instance_variable_get(:@access_token)).to eql('accessToken')
      expect(token_client.instance_variable_get(:@access_token_expiration)).to be_a(Time)
    end

    it 'should refresh expired token and pass bearer auth header' do
      expired_token_client.stubs.post('https://api.bandwidth.com/api/v1/oauth2/token') { |env| [200, {}, '{"access_token":"newAccessToken","expires_in":3600}'] }
      expired_token_client.stubs.get('/v1.0/test-auth-expired-token') { |env| [200, {}, "<Result><EchoedAuth>#{env[:request_headers]['Authorization']}</EchoedAuth></Result>"] }
      expect(expired_token_client.make_request(:get, '/test-auth-expired-token')).to eql([{:echoed_auth=>"Bearer newAccessToken"}, {}])
      expect(expired_token_client.instance_variable_get(:@access_token)).to eql('newAccessToken')
      expect(expired_token_client.instance_variable_get(:@access_token_expiration)).to be_a(Time)
    end

    it 'should use client credentials to get token and pass bearer auth header' do
      client_credentials_client.stubs.post('https://api.bandwidth.com/api/v1/oauth2/token') { |env| [200, {}, '{"access_token":"clientCredentialsAccessToken","expires_in":3600}'] }
      client_credentials_client.stubs.get('/v1.0/test-auth-client-credentials') { |env| [200, {}, "<Result><EchoedAuth>#{env[:request_headers]['Authorization']}</EchoedAuth></Result>"] }
      expect(client_credentials_client.make_request(:get, '/test-auth-client-credentials')).to eql([{:echoed_auth=>"Bearer clientCredentialsAccessToken"}, {}])
      expect(client_credentials_client.instance_variable_get(:@access_token)).to eql('clientCredentialsAccessToken')
      expect(client_credentials_client.instance_variable_get(:@access_token_expiration)).to be_a(Time)
    end

    it 'should make GET request and return xml  data' do
      client.stubs.get('/v1.0/path1') { |env| [200, {}, '<Result><Test>data</Test></Result>'] }
      client.stubs.get('/v1.0/path2?testField=10') { |env| [200, {'Location'=>'url'}, '<Root><TestValue>10</TestValue><DataArray>1</DataArray><DataArray>2</DataArray><BoolValue>true</BoolValue><BoolValue2>false</BoolValue2><DateTimeValue>2015-05-29T01:02:03Z</DateTimeValue></Root>'] }
      expect(client.make_request(:get, '/path1')).to eql([{:test => 'data'}, {}])
      expect(client.make_request(:get, '/path2', {:test_field => 10})).to eql([{:test_value => 10, :data_array => [1, 2], :bool_value => true, :bool_value2 => false, :date_time_value => DateTime.new(2015,5,29,1,2,3)}, {:location=>'url'}])
    end

    it 'should make POST request and return xml data' do
      client.stubs.post('/v1.0/path1', '<?xml version="1.0" encoding="UTF-8"?><Request><TestField1>test</TestField1><TestField2>019</TestField2><TestField3>false</TestField3><TestFieldd4>2015-05-29T01:02:03+00:00</TestFieldd4></Request>')  { |env|  [200, {}, '<Response><Success>true</Success></Response>'] }
      expect(client.make_request(:post, '/path1', {:request => {:test_field1 => "test", :test_field2 => "019", :test_field3 => false, :test_fieldd4 => DateTime.new(2015, 5, 29, 1,2,3)}})[0]).to eql(:success => true)
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
      client.stubs.get('/v1.0/path1') { |env| [400, {'content-type'=>'application/xml'}, '<SearchResult><Error><Code>4010</Code><Description>The state abbreviation N is not valid.</Description></Error></SearchResult>'] }
      expect{client.make_request(:get, '/path1')}.to raise_error(an_instance_of(Errors::GenericError).and having_attributes({
        http_status: 400,
        headers: {"content-type"=>"application/xml"},
        body: {:error=>{:code=>4010, :description=>"The state abbreviation N is not valid."}}
      }))
    end
  end
end

describe '#build_xml' do
  client = nil
  before :each do
    client = Helper.get_client()
  end

  it 'should generate valid XML' do
    expect(client.build_xml({root: {item: {value: '123'}}})).to eql('<?xml version="1.0" encoding="UTF-8"?><Root><Item><Value>123</Value></Item></Root>')
    expect(client.build_xml({root: {item: [1,2,3]}})).to eql('<?xml version="1.0" encoding="UTF-8"?><Root><Item>1</Item><Item>2</Item><Item>3</Item></Root>')
    expect(client.build_xml({root: {item: [{value: '111'}, {value: '222'}]}})).to eql('<?xml version="1.0" encoding="UTF-8"?><Root><Item><Value>111</Value></Item><Item><Value>222</Value></Item></Root>')
    expect(client.build_xml({root: {item: [{value: [1,2,3]}, {value: '222'}]}})).to eql('<?xml version="1.0" encoding="UTF-8"?><Root><Item><Value>1</Value><Value>2</Value><Value>3</Value></Item><Item><Value>222</Value></Item></Root>')
  end
end
