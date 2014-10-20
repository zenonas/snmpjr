require production_code

describe Snmpjr::Walker do
  let(:target) { double :target }
  let(:session) { double Snmpjr::Session }
  let(:pdu_factory) { double Snmpjr::Wrappers::Util::DefaultPDUFactory }
  let(:tree_util) { double Snmpjr::Wrappers::Util::TreeUtil }

  subject { described_class.new(target: target) }

  let(:tree_event_1) { double :tree_event_1 }
  let(:tree_event_2) { double :tree_event_2 }
  let(:example_event_responses) { [tree_event_1, tree_event_2] }

  before do
    allow(Snmpjr::Wrappers::Util::DefaultPDUFactory).to receive(:new).and_return pdu_factory
    allow(pdu).to receive(:create).with(['1.2.3.4.5.6']).and_return created_pdu_single
    allow(Snmpjr::Session).to receive(:new).and_return session
    allow(session).to receive(:start)
    allow(session).to receive(:close)

    allow(Snmpjr::Wrappers::Util::TreeUtil).to receive(:new).with(session.snmp, pdu_factory).and_return tree_util
    allow(tree_util).to receive(:getSubtree).and_return example_event_responses
  end

  describe '#walk' do
    it 'starts an snmp session' do
      subject.walk '1.2.3.4.5.6'
      expect(session).to have_received(:start)
    end

    it 'performs a synchronous walk' do
      expect(subject.walk '1.2.3.4.5.6').to eq 'Foo'
    end

    it 'closes the snmp session' do
      subject.walk '1.2.3.4.5.6'
      expect(session).to have_received(:close)
    end
  end
end
