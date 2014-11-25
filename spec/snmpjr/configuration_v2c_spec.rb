require production_code

describe Snmpjr::ConfigurationV2C do
  describe '#create_pdu' do
    it 'creates a new PduV2 instance' do
      expect(subject.create_pdu).to be_a Snmpjr::PduV2C
    end
  end

  describe '#create_target' do
    let(:target) { double :target }
    let(:created_target) { double :created_target }

    before do
      allow(Snmpjr::TargetV2C).to receive(:new).and_return target
      allow(target).to receive(:create).with(subject).and_return created_target
    end

    it 'creates a target for snmp v2' do
      subject.create_target
      expect(subject.create_target).to eq created_target
    end
  end

  describe '#create_session' do
    it 'creates a session for snmp v2' do
      expect(subject.create_session).to be_a Snmpjr::SessionV2C
    end
  end
end
