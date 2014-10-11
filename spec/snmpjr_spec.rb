require production_code

describe Snmpjr do
  describe "#get" do
    context "when the call is synchronous" do

      let(:target) { double Snmpjr::Target }
      let(:community_target) { double :community_target }
      let(:session) { double Snmpjr::Session }
      let(:pdu) { double Snmpjr::Pdu }
      let(:created_pdu) { double :created_pdu }

      before do
        allow(Snmpjr::Pdu).to receive(:new).and_return pdu
        allow(pdu).to receive(:create).with('1.2.3.4.5.6').and_return created_pdu
        allow(Snmpjr::Session).to receive(:new).and_return session
        allow(session).to receive(:send)
        allow(Snmpjr::Target).to receive(:new).and_return target
        allow(target).to receive(:create).with(agent_details).and_return community_target
      end

      let(:agent_details) { { :host => '127.0.0.1', :port => 161, :community => 'some_community' } }

      subject { described_class.new(agent_details) }

      it "performs a synchronous get" do
        subject.get '1.2.3.4.5.6'
        expect(session).to have_received(:send).with(created_pdu, community_target)
      end
    end
  end
end
