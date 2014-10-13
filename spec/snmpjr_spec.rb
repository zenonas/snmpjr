require production_code

describe Snmpjr do
  describe "#get" do
    context "when the call is synchronous" do

      let(:target) { double Snmpjr::Target }
      let(:community_target) { double :community_target }
      let(:getter) { double Snmpjr::Getter }

      before do
        allow(Snmpjr::Target).to receive(:new).and_return target
        allow(target).to receive(:create).with(agent_details).and_return community_target
        allow(Snmpjr::Getter).to receive(:new).with(community_target).and_return getter
      end

      let(:agent_details) { { :host => '127.0.0.1', :port => 161, :community => 'some_community' } }

      subject { described_class.new(agent_details) }

      context 'when passed a single oid' do
        it 'performs a synchronous get' do
          expect(getter).to receive(:get).with('1.2.3.4.5.6')
          subject.get '1.2.3.4.5.6'
        end
      end

      context 'when passed multiple oids' do
        it 'performs a get multiple using the getter' do
          expect(getter).to receive(:get_multiple).with(['1.2.3.4.5.6', '6.5.4.3.2.1'])
          subject.get ['1.2.3.4.5.6', '6.5.4.3.2.1']
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
