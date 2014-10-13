require production_code

describe Snmpjr::Getter do
  let(:target) { double :target }
  let(:session) { double Snmpjr::Session }
  let(:pdu) { double Snmpjr::Pdu }
  let(:created_pdu_1) { double :created_pdu_1 }

  subject { described_class.new(target) }

  before do
    allow(Snmpjr::Pdu).to receive(:new).and_return pdu
    allow(pdu).to receive(:create).with('1.2.3.4.5.6').and_return created_pdu_1
    allow(Snmpjr::Session).to receive(:new).and_return session
    allow(session).to receive(:start)
    allow(session).to receive(:send)
    allow(session).to receive(:close)
  end

  describe "#get_multiple" do
    let(:created_pdu_2) { double :created_pdu_2 }

    before do
      allow(pdu).to receive(:create).with('6.5.4.3.2.1').and_return created_pdu_2
    end

    it 'starts an snmp session' do
      subject.get_multiple ['1.2.3.4.5.6', '6.5.4.3.2.1']
      expect(session).to have_received(:start)
    end

    it 'performs multiple gets for each oid' do
      subject.get_multiple ['1.2.3.4.5.6', '6.5.4.3.2.1']
      expect(session).to have_received(:send).with(created_pdu_1, target)
      expect(session).to have_received(:send).with(created_pdu_2, target)
    end

    it 'closes the snmp session' do
      subject.get_multiple ['1.2.3.4.5.6', '6.5.4.3.2.1']
      expect(session).to have_received(:close)
    end
  end

  describe "#get" do
    it 'starts an snmp session' do
      subject.get '1.2.3.4.5.6'
      expect(session).to have_received(:start)
    end

    it 'performs a synchronous get' do
      subject.get '1.2.3.4.5.6'
      expect(session).to have_received(:send).with(created_pdu_1, target)
    end

    it 'closes the snmp session' do
      subject.get '1.2.3.4.5.6'
      expect(session).to have_received(:close)
    end
  end
end
