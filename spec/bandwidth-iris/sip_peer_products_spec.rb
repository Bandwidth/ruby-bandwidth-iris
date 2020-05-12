describe BandwidthIris::SipPeerProducts do
  client = nil

  before :each do
    client = Helper.get_client()
  end

  after :each do
    client.stubs.verify_stubbed_calls()
  end

  describe '#originationSettings' do
    it 'should get origination settings' do
    end
    it 'should create origination settings' do
    end
    it 'should update origination settings' do
    end
  end

  describe '#terminationSettings' do
    it 'should get termination settings' do
    end
    it 'should create termination settings' do
    end
    it 'should update termination settings' do
    end
  end

  describe '#smsFeatureSettings' do
    it 'should get sms feature settings' do
    end
    it 'should create sms feature settings' do
    end
    it 'should update sms feature settings' do
    end
    it 'should delete sms feature settings' do
    end
  end

  describe '#mmsFeatureSettings' do
    it 'should get mms feature settings' do
    end
    it 'should create mms feature settings' do
    end
    it 'should update mms feature settings' do
    end
    it 'should delete mms feature settings' do
    end
  end

  describe '#mmsFeatureMmsSettings' do
    it 'should get mms feature mms settings' do
    end
  end

  describe '#messagingApplicationSettings' do
    it 'should get messaging application settings' do
    end
    it 'should update messaging application settings' do
    end
  end

  describe '#messagingSettings' do
    it 'should get messaging settings' do
    end
    it 'should update messaging settings' do
    end
  end
end
