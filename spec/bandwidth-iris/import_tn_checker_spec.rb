describe BandwidthIris::ImportTnChecker do
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
        :telephone_numbers => {
            :telephone_number => ["5554443333", "5553334444"]
        }
      }
      client.stubs.post('/v1.0/accounts/accountId/importTnChecker', client.build_xml({:import_tn_checker_payload => data})) {|env| [200, {}, Helper.xml['import_tn_checker']]}
      item = ImportTnChecker.check_tns_portability(client, data)
      expect(item[0][:telephone_numbers][:telephone_number][0]).to eql(data[:telephone_numbers][:telephone_number][0])
    end
  end
end
