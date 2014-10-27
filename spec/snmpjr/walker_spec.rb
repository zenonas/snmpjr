require production_code

describe Snmpjr::Walker do
  let(:target) { double :target }
  let(:oid) { Snmpjr::Wrappers::SMI::OID.new '1.2.3.4.5.6' }
  let(:session) { double(:session).as_null_object }

  let(:pdu_factory) { double Snmpjr::Wrappers::Util::DefaultPDUFactory }
  let(:tree_util) { double Snmpjr::Wrappers::Util::TreeUtils }

  subject { described_class.new(target: target) }

  let(:vb1) { Snmpjr::Wrappers::SMI::VariableBinding.new(
    Snmpjr::Wrappers::SMI::OID.new('1.3.6'),
    Snmpjr::Wrappers::SMI::OctetString.new('Sample Result 1'))
  }

  let(:vb2) { Snmpjr::Wrappers::SMI::VariableBinding.new(
    Snmpjr::Wrappers::SMI::OID.new('1.3.6.1'),
    Snmpjr::Wrappers::SMI::OctetString.new('Sample Result 2'))
  }
  let(:tree_event_1) { double :tree_event_1, {variable_bindings: [vb1], is_error?: false} }
  let(:tree_event_2) { double :tree_event_2, {variable_bindings: [vb2], is_error?: false} }
  let(:example_event_responses) { [tree_event_1, tree_event_2] }

  before do
    allow(Snmpjr::Wrappers::Util::DefaultPDUFactory).to receive(:new).and_return pdu_factory
    allow(Snmpjr::Session).to receive(:new).and_return session

    allow(Snmpjr::Wrappers::Util::TreeUtils).to receive(:new).with(session.snmp, pdu_factory).and_return tree_util
    allow(tree_util).to receive(:getSubtree).with(target, oid).and_return example_event_responses
  end

  describe '#walk' do
    it 'starts an snmp session' do
      expect(session).to receive(:start)
      subject.walk  oid
    end

    context 'when an exception is raised' do
      before do
        allow(tree_util).to receive(:getSubtree).with(target, oid).and_raise Exception.new 'noAccess'
      end
      it 'raises a runtime error' do
        expect{
          subject.walk oid
        }.to raise_error RuntimeError
      end
    end

    context 'when a target times out' do
      let(:tree_event_1) { double :tree_event_1 }
      before do
        allow(tree_event_1).to receive(:is_error?).and_return true
        allow(tree_event_1).to receive(:error_message).and_return 'Request timed out.'
      end

      it 'raises a timeout error' do
        expect{
          subject.walk oid
        }.to raise_error Snmpjr::TargetTimeoutError
      end

    end

    context 'when a walk returns no variable bindings' do
      let(:tree_event) { double :tree_event, {variable_bindings: [], is_error?: false } }
      let(:example_event_responses) { [tree_event] }

      it 'returns an empty array' do
        expect(subject.walk oid).to eq []
      end
    end

    it 'performs a synchronous walk' do
      expect(subject.walk oid).to match_array [Snmpjr::Response.new(value: vb1.variable.to_s),
                                                         Snmpjr::Response.new(value: vb2.variable.to_s)]
    end

    it 'closes the snmp session' do
      expect(session).to receive(:close)
      subject.walk oid
    end
  end
end
