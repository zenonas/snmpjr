require production_code

describe Snmpjr do
  describe "#get" do
    context "when the call is synchronous" do

      let(:target) { double Snmpjr::Target }
      let(:session) { double Snmpjr::Session }
      let(:pdu) { double Snmpjr::Pdu }

      before do
        allow(Snmpjr::Pdu).to receive(:new).and_return pdu
        allow(Snmpjr::Session).to receive(:new).and_return session
        allow(session).to receive(:send)
        allow(Snmpjr::Target).to receive(:new).and_return target
      end

      let(:agent_details) { { :host => '127.0.0.1', :port => 161, :community => 'some_community' } }

      subject { described_class.new(agent_details) }
      it "performs a synchronous get" do
        expect(Snmpjr::Pdu).to receive(:new).with '1.2.3.4.5.6'
        expect(Snmpjr::Target).to receive(:new).with(agent_details)
        subject.get '1.2.3.4.5.6'
        expect(session).to have_received(:send).with(target, pdu)
      end
    end
  end
end
