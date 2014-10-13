require production_code

describe Snmpjr::Session do

  let(:transport_mapping) { double Snmpjr::Wrappers::Transport::DefaultUdpTransportMapping }
  let(:snmp_session) { double Snmpjr::Wrappers::Snmp }

  before do
    allow(Snmpjr::Wrappers::Transport::DefaultUdpTransportMapping).to receive(:new).and_return transport_mapping
    allow(Snmpjr::Wrappers::Snmp).to receive(:new).and_return snmp_session
    allow(snmp_session).to receive(:listen)
    allow(snmp_session).to receive(:send)
    allow(snmp_session).to receive(:close)
  end

  describe "#start" do

    it "opens a new SNMP4J session with Udp transport mapping" do
      subject.start
      expect(Snmpjr::Wrappers::Snmp).to have_received(:new).with(transport_mapping)
    end

    it "calls the listen method on the Snmp session" do
      subject.start
      expect(snmp_session).to have_received(:listen)
    end

  end

  describe "#send" do
    let(:result) { double :result }
    let(:pdu) { double :pdu }
    let(:target) { double :target }

    before do
      allow(snmp_session).to receive(:send).and_return result
      allow(result).to receive_message_chain('response.variable_bindings.first.variable.to_s')
    end

    it "sends the pdu to the target" do
      expect(snmp_session).to receive(:send).with(pdu, target)
      subject.send(pdu, target)
    end

    context 'the requests times out' do
      before do
        allow(result).to receive(:response).and_return nil
      end

      it 'returns a request timeout' do
        expect(subject.send(pdu, target)).to eq "Request timed out"
      end
    end

    context 'an exception is raised' do
      before do
        allow(snmp_session).to receive(:send).and_raise(RuntimeError.new('Some error'))
      end

      it 'returns the error without blowing up' do
        expect(subject.send(pdu, target)).to eq "Error: Some error"
      end
    end
  end

  describe "#close" do
    it "closes the snmp session" do
      subject.close
      expect(snmp_session).to have_received(:close)
    end
  end
end
