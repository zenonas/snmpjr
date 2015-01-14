require production_code

describe Snmpjr::SessionV2C do

  let(:transport_mapping) { double Snmpjr::Wrappers::Transport::DefaultUdpTransportMapping }
  let(:snmp_session) { double Snmpjr::Wrappers::Snmp }

  before do
    allow(Snmpjr::Wrappers::Transport::DefaultUdpTransportMapping).to receive(:new).and_return transport_mapping
    allow(Snmpjr::Wrappers::Snmp).to receive(:new).and_return snmp_session
    allow(snmp_session).to receive(:listen)
    allow(snmp_session).to receive(:send)
    allow(snmp_session).to receive(:close)
  end

  describe '#start' do

    it 'opens a new SNMP4J session with Udp transport mapping' do
      subject.start
      expect(Snmpjr::Wrappers::Snmp).to have_received(:new).with(transport_mapping)
    end

    it 'calls the listen method on the Snmp session' do
      subject.start
      expect(snmp_session).to have_received(:listen)
    end
  end

  describe '#send' do
    let(:vb1) { double :vb1 }
    let(:vb2) { double :vb2 }
    let(:results) { [vb1, vb2] }
    let(:response) { double :response }
    let(:pdu) { double :pdu, to_array: [vb1, vb2] }
    let(:address) { double :address, to_s: "1.2.3.4/567" }
    let(:target) { double :target, address: address }

    before do
      allow(snmp_session).to receive(:send).and_return response
      allow(vb1).to receive_message_chain('variable.syntax_string')
      allow(vb1).to receive_message_chain('variable.to_s')
      allow(vb1).to receive_message_chain('oid.to_s') { "1.2.3" }
      allow(vb1).to receive(:is_exception)
      allow(vb2).to receive_message_chain('variable.syntax_string')
      allow(vb2).to receive_message_chain('variable.to_s')
      allow(vb2).to receive_message_chain('oid.to_s') { "4.5.6" }
      allow(vb2).to receive(:is_exception)
      allow(response).to receive_message_chain('response.variable_bindings').and_return(results)
    end

    it 'sends the pdu to the target' do
      expect(snmp_session).to receive(:send).with(pdu, target)
      subject.send(pdu, target)
    end

    context 'the requests times out' do
      before do
        allow(response).to receive(:response).and_return nil
      end

      it 'raises a timeout error' do
        expect {
          subject.send(pdu, target)
        }.to raise_error(Snmpjr::TargetTimeoutError, 'Request timed out: 1.2.3.4/567, OIDs: ["1.2.3", "4.5.6"]')
      end
    end

    context 'an exception is raised' do
      let(:exception) { Exception.new "An error" }
      before do
        allow(snmp_session).to receive(:send).and_raise(exception)
      end

      it 'catches it and raises a ruby runtime error' do
        expect{
          subject.send(pdu, target)
        }.to raise_error(RuntimeError, %{#{exception.inspect}: 1.2.3.4/567, OIDs: ["1.2.3", "4.5.6"]})
      end
    end
  end

  describe '#close' do
    it 'closes the snmp session' do
      subject.close
      expect(snmp_session).to have_received(:close)
    end
  end
end
