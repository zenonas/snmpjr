require production_code

describe Snmpjr do
  let(:target) { double Snmpjr::Target }
  let(:community_target) { double :community_target }
  let(:agent_details) { { host: '127.0.0.1', port: 161, community: 'some_community', timeout: 50, retries: 50 } }

  subject { described_class.new(agent_details) }

  before do
    allow(Snmpjr::Target).to receive(:new).and_return target
    allow(target).to receive(:create).with(agent_details).and_return community_target
  end

  describe "#get" do
    let(:getter) { double Snmpjr::Getter }

    before do
      allow(Snmpjr::Getter).to receive(:new).with(target: community_target, max_oids_per_request: 20).and_return getter
    end


    subject { described_class.new(agent_details.merge({max_oids_per_request: 20})) }

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

  describe '#walk' do
    let(:walker) { double Snmpjr::Walker }
    let(:oid) { double :oid }

    before do
      allow(Snmpjr::Walker).to receive(:new).with(target: community_target).and_return walker
      allow(Snmpjr::Wrappers::SMI::OID).to receive(:new).with('1.3.6.1.1').and_return oid
    end
    context 'when a string is passed' do
      it 'performs a synchronous walk' do
        expect(walker).to receive(:walk).with(oid)
        subject.walk '1.3.6.1.1'
      end
    end

    context 'when anything else is passed in' do
      it 'raises an ArgumentError' do
        expect {
          subject.walk({'oid_value' => '1.3.4.5.6'})
        }.to raise_error ArgumentError
      end
    end

  end
end
