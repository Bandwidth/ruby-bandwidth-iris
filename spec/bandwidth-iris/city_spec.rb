describe BandwidthIris::City do
  client = nil

  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#list' do
    it 'should return cities' do
      client.stubs.get('/v1.0/cities?state=NC') {|env| [200, {}, Helper.xml['cities']]}
      expect(City.list(client, {:state => 'NC'})).to eql([
        { :rc_abbreviation => "SOUTHEPINS", :name => "ABERDEEN" },
        { :rc_abbreviation => "JULIAN", :name => "ADVANCE" }
      ])
    end
  end

end
