require production_code

describe Snmpjr::Target do

  describe "#create" do
    let(:options) { { :host => '127.0.0.1', :port => 161, :community => 'some_community', :timeout => 50 } }

    it "creates an octet string for the community string" do
      expect(Snmpjr::Wrappers::SMI::OctetString).to receive(:new).with(options[:community])
      subject.create(options)
    end

    it "creates an smi address based on the ip and port name" do
      expect(Snmpjr::Wrappers::SMI::GenericAddress).to receive(:parse).with("udp:127.0.0.1/161")
      subject.create(options)
    end

    let(:community_target) { double Snmpjr::Wrappers::CommunityTarget }

    before do
      allow(Snmpjr::Wrappers::CommunityTarget).to receive(:new).and_return community_target
      allow(community_target).to receive(:version=)
      allow(community_target).to receive(:timeout=)
      allow(community_target).to receive(:community=)
      allow(community_target).to receive(:address=)
    end

    it "sets the snmp version to v2c and the timeout to 50ms" do
      expect(community_target).to receive(:version=).with(1)
      expect(community_target).to receive(:timeout=).with(50)
      subject.create(options)
    end

    it "returns the SNMP4J community target" do
      expect(subject.create(options).class).to eq community_target.class
    end
  end
end
