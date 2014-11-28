require production_code

describe Snmpjr::ConfigurationV3 do
  describe '#create_pdu' do
    it 'creates a new PduV3 instance' do
      expect(subject.create_pdu).to be_a Snmpjr::PduV3
    end

    it 'assigns a context to it' do
      subject.context = 'some_context'
      expect(Snmpjr::PduV3).to receive(:new).with('some_context')
      subject.create_pdu
    end
  end

  describe '#create_target' do
    let(:target) { double :target }
    let(:created_target) { double :created_target }

    before do
      allow(Snmpjr::TargetV3).to receive(:new).and_return target
      allow(target).to receive(:create).with(subject).and_return created_target
    end

    it 'creates a target for snmp v3' do
      subject.create_target
      expect(subject.create_target).to eq created_target
    end
  end

  describe '#create_session' do
    let(:created_session) { double :created_session }

    before do
      allow(Snmpjr::SessionV3).to receive(:new).with(subject).and_return created_session
    end

    it 'creates a session for snmp v3' do
      subject.create_session
      expect(subject.create_session).to eq created_session
    end
  end
end
