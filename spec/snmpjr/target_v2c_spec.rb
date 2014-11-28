require 'snmpjr/configuration_v2c'
require production_code

describe Snmpjr::TargetV2C do

  describe '#create' do
    let(:configuration) do
      config = Snmpjr::ConfigurationV2C.new
      config.host = '127.0.0.1'
      config.port = 161
      config.community = 'some community'
      config.retries = 2
      config.timeout = 50
      config
    end

    it 'creates an octet string for the community string' do
      expect(Snmpjr::Wrappers::SMI::OctetString).to receive(:new).with(configuration.community)
      subject.create(configuration)
    end

    it 'creates an smi address based on the ip and port name' do
      expect(Snmpjr::Wrappers::SMI::GenericAddress).to receive(:parse).with("udp:127.0.0.1/161")
      subject.create(configuration)
    end

    let(:community_target) { double Snmpjr::Wrappers::CommunityTarget }

    before do
      allow(Snmpjr::Wrappers::CommunityTarget).to receive(:new).and_return community_target
      allow(community_target).to receive(:version=)
      allow(community_target).to receive(:timeout=)
      allow(community_target).to receive(:community=)
      allow(community_target).to receive(:address=)
      allow(community_target).to receive(:retries=)
    end

    it 'sets the snmp version to v2c and the timeout to 50ms' do
      expect(community_target).to receive(:version=).with(1)
      expect(community_target).to receive(:timeout=).with(50)
      expect(community_target).to receive(:retries=).with(2)
      subject.create(configuration)
    end

    it 'returns the SNMP4J community target' do
      expect(subject.create(configuration)).to eq(community_target)
    end
  end
end
