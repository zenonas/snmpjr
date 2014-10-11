require production_code

describe Snmpjr::Session do
  describe "#send" do
    let(:transport_mapping) { double Snmpjr::Wrappers::Transport::DefaultUdpTransportMapping }

    let(:target) { double :target }
    let(:pdu) { double :pdu }
    let(:result) { double :result }

    let(:snmp_session) { double Snmpjr::Wrappers::Snmp }

    before do
      allow(Snmpjr::Wrappers::Transport::DefaultUdpTransportMapping).to receive(:new).and_return transport_mapping
      allow(Snmpjr::Wrappers::Snmp).to receive(:new).and_return snmp_session
      allow(snmp_session).to receive(:send).and_return result
      allow(result).to receive_message_chain('response.variable_bindings.first.variable.to_s')
      allow(snmp_session).to receive(:listen)
      allow(snmp_session).to receive(:close)
    end
    it "opens a new SNMP4J session with Udp transport mapping" do
      expect(Snmpjr::Wrappers::Snmp).to receive(:new).with(transport_mapping)
      subject.send(pdu, target)
    end

    it "sends the pdu to the target" do
      expect(snmp_session).to receive(:send).with(pdu, target)
      subject.send(pdu, target)
    end

    it "closes the connection" do
      expect(snmp_session).to receive(:close)
      subject.send(pdu, target)
    end

  end
end
