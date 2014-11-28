require production_code
require 'snmpjr/configuration'

describe Snmpjr::Getter do
  let(:target) { double :target }
  let(:session) { double :session }
  let(:pdu) { double :pdu }
  let(:created_pdu_single) { double :created_pdu_single }

  let(:configuration) { Snmpjr::Configuration.new }

  subject { described_class.new(session: session, target: target, pdu: pdu, config: configuration) }

  before do
    allow(session).to receive(:start)
    allow(session).to receive(:send).with(created_pdu_single, target).and_return ['Foo']
    allow(session).to receive(:close)
  end

  describe '#get' do
    let(:created_pdu_multiple_1) { double :created_pdu_multiple_1 }
    let(:created_pdu_multiple_2) { double :created_pdu_multiple_2 }

    before do
      configuration.max_oids_per_request = 1
      allow(pdu).to receive(:create).with(['1.2.3.4.5.6']).and_return created_pdu_multiple_1
      allow(pdu).to receive(:create).with(['6.5.4.3.2.1']).and_return created_pdu_multiple_2
      allow(session).to receive(:send).with(created_pdu_multiple_1, target).and_return ['Foo']
      allow(session).to receive(:send).with(created_pdu_multiple_2, target).and_return ['Bar']
    end

    context 'when there is a single oid' do
      before do
        allow(pdu).to receive(:create).with(['1.2.3.4.5.6']).and_return created_pdu_single
      end

      it 'performs a synchronous get' do
        expect(subject.get ['1.2.3.4.5.6']).to eq ['Foo']
        expect(session).to have_received(:send).with(created_pdu_single, target)
      end
    end

    context 'when there are multiple oids' do
      it 'performs multiple gets for each oid' do
        expect(subject.get ['1.2.3.4.5.6', '6.5.4.3.2.1']).to eq(['Foo', 'Bar'])
        expect(session).to have_received(:send).with(created_pdu_multiple_1, target)
        expect(session).to have_received(:send).with(created_pdu_multiple_2, target)
      end
    end

    it 'starts an snmp session' do
      subject.get ['1.2.3.4.5.6', '6.5.4.3.2.1']
      expect(session).to have_received(:start)
    end

    it 'closes the snmp session' do
      subject.get ['1.2.3.4.5.6', '6.5.4.3.2.1']
      expect(session).to have_received(:close)
    end
  end
end
