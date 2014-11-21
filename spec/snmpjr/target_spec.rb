require production_code

describe Snmpjr::Target do

  describe '#create' do
    context 'when we have a V2C config' do
      let(:configuration) do
        config = Snmpjr::ConfigurationV2C.new
        config.host = '127.0.0.1'
        config.port = 161
        config.community = 'some community'
        config.retries = 2
        config.timeout = 50
        config
      end

      let(:target_v2c) { double :target_v2c }
      let(:community_target) { double :community_target }

      before do
        allow(Snmpjr::TargetV2C).to receive(:new).and_return(target_v2c)
        allow(target_v2c).to receive(:create).with(configuration).and_return community_target
      end

      it 'returns a V2C Target' do
        expect(Snmpjr::Target.new.create(configuration)).to eq(community_target)
      end
    end

    context 'when we have a V3 config' do
      let(:configuration) do
        config = Snmpjr::ConfigurationV3.new
        config.host = '127.0.0.1'
        config.port = 161
        config.context = '80004fb805636c6f75644dab22cc'
        config.user = 'username'
        config.security_level = 'authPriv'
        config.authentication_protocol = 'SHA'
        config.authentication_key = 'authkey1'
        config.privacy_protocol = 'DES'
        config.privacy_key = 'privkey1'
        config.timeout = 50
        config
      end

      let(:target_v3) { double :target_v3 }
      let(:user_target) { double :user_target }

      before do
        allow(Snmpjr::TargetV3).to receive(:new).and_return(target_v3)
        allow(target_v3).to receive(:create).with(configuration).and_return user_target
      end

      it 'returns a V3 target' do
        expect(Snmpjr::Target.new.create(configuration)).to eq(user_target)
      end

    end
  end
end
