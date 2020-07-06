describe BandwidthIris::TnOptions do
  client = nil

  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe "#tnOptionOrders" do
    it "should get tn option orders" do
      client.stubs.get("/v1.0/accounts/accountId/tnoptions"){|env| [200, {}, Helper.xml['tnOptionOrders']]}
      orders = TnOptions.get_tn_option_orders(client)
      expect(orders[:tn_option_order_summary][0][:account_id]).to eql(14)
    end

    it "should create tn option order" do
      data = {
        :customer_order_id => "12345",
        :tn_option_groups => {
          :tn_option_group => [
            {
              :number_format => "10digit",
              :RPIDFormat => "10digit"
            }
          ]
        }
      }
      client.stubs.post("/v1.0/accounts/accountId/tnoptions", client.build_xml({:tn_option_order => data})){|env| [200, {}, Helper.xml['tnOptionOrderResponse']]}
      order = TnOptions.create_tn_option_order(client, data)
      expect(order[:account_id]).to eql(14)
    end

    it "should get tn option order" do
      client.stubs.get("/v1.0/accounts/accountId/tnoptions/id"){|env| [200, {}, Helper.xml['tnOptionOrder']]}
      order = TnOptions.get_tn_option_order(client, "id")
      expect(order[:account_id]).to eql(14)
    end
  end
end
