require production_code

describe Snmpjr::Pdu do
  describe "#create" do

    let(:pdu) { double Snmpjr::Wrappers::PDU }
    let(:oid_1) { double Snmpjr::Wrappers::SMI::OID }
    let(:oid_2) { double Snmpjr::Wrappers::SMI::OID }
    let(:variable_binding_1) { double Snmpjr::Wrappers::SMI::VariableBinding }
    let(:variable_binding_2) { double Snmpjr::Wrappers::SMI::VariableBinding }

    before do
      allow(Snmpjr::Wrappers::PDU).to receive(:new).and_return pdu
      allow(Snmpjr::Wrappers::SMI::OID).to receive(:new).with('1.2.3.4').and_return oid_1
      allow(Snmpjr::Wrappers::SMI::OID).to receive(:new).with('5.6.7.8').and_return oid_2
      allow(Snmpjr::Wrappers::SMI::VariableBinding).to receive(:new).with(oid_1).and_return variable_binding_1
      allow(Snmpjr::Wrappers::SMI::VariableBinding).to receive(:new).with(oid_2).and_return variable_binding_2
      allow(pdu).to receive(:type=)
      allow(pdu).to receive(:add)
    end
    it "creates a GET Pdu" do
      expect(pdu).to receive(:type=).with(Snmpjr::Pdu::Constants::GET)
      subject.create ['1.2.3.4']
    end

    it "adds an SMI variable binding containing an oid to the pdu" do
      expect(pdu).to receive(:add).with variable_binding_1
      expect(pdu).to receive(:add).with variable_binding_2
      subject.create ['1.2.3.4', '5.6.7.8']
    end
  end
end
