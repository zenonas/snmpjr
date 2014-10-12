require production_code

describe Snmpjr do
  describe "#get" do
    context "when the call is synchronous" do

      let(:target) { double Snmpjr::Target }
      let(:community_target) { double :community_target }
      let(:session) { double Snmpjr::Session }
      let(:pdu) { double Snmpjr::Pdu }
      let(:created_pdu_1) { double :created_pdu_1 }

      before do
        allow(Snmpjr::Pdu).to receive(:new).and_return pdu
        allow(pdu).to receive(:create).with('1.2.3.4.5.6').and_return created_pdu_1
        allow(Snmpjr::Session).to receive(:new).and_return session
        allow(session).to receive(:send)
        allow(Snmpjr::Target).to receive(:new).and_return target
        allow(target).to receive(:create).with(agent_details).and_return community_target
      end

      let(:agent_details) { { :host => '127.0.0.1', :port => 161, :community => 'some_community' } }

      subject { described_class.new(agent_details) }

      context 'when passed a single oid' do
        it 'performs a synchronous get' do
          subject.get '1.2.3.4.5.6'
          expect(session).to have_received(:send).with(created_pdu_1, community_target)
        end
      end

      context 'when passed multiple oids' do
        let(:created_pdu_2) { double :created_pdu_2 }

        before do
          allow(pdu).to receive(:create).with('6.5.4.3.2.1').and_return created_pdu_2
        end

        it 'performs multiple gets for each oid' do
          subject.get ['1.2.3.4.5.6', '6.5.4.3.2.1']
          expect(session).to have_received(:send).with(created_pdu_1, community_target)
          expect(session).to have_received(:send).with(created_pdu_2, community_target)
        end
      end

      context 'when an invalid argument was passed in' do
        it 'raises an ArgumentError' do
          expect {
            subject.get({'oid_value' => '1.3.4.5.6'})
          }.to raise_error ArgumentError
        end
      end
    end
  end
end
