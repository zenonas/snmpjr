require production_code

describe Snmpjr::Pdu do
  describe "#create" do

    let(:pdu) { double Snmpjr::Wrappers::PDU }
    let(:oid) { double Snmpjr::Wrappers::SMI::OID }
    let(:variable_binding) { double Snmpjr::Wrappers::SMI::VariableBinding }

    before do
      allow(Snmpjr::Wrappers::PDU).to receive(:new).and_return pdu
      allow(Snmpjr::Wrappers::SMI::OID).to receive(:new).and_return oid
      allow(Snmpjr::Wrappers::SMI::VariableBinding).to receive(:new).and_return variable_binding
      allow(pdu).to receive(:type=)
      allow(pdu).to receive(:add)
    end
    it "creates a GET Pdu" do
      expect(pdu).to receive(:type=).with(Snmpjr::Pdu::Constants::GET)
      subject.create '1.2.3.4'
    end

    it "adds an SMI variable binding containing an oid to the pdu" do
      expect(Snmpjr::Wrappers::SMI::OID).to receive(:new).with('1.2.3.4')
      expect(Snmpjr::Wrappers::SMI::VariableBinding).to receive(:new).with(oid)
      expect(pdu).to receive(:add).with variable_binding
      subject.create '1.2.3.4'
    end
  end
end
