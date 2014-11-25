require production_code

describe Snmpjr do
  let(:target) { double :target }
  let(:configuration) { double :configuration }
  let(:created_target) { double :created_target }

  subject { described_class.new(Snmpjr::Version::V2C) }

  before do
    allow(Snmpjr::Target).to receive(:new).and_return target
    allow(target).to receive(:create).and_return created_target
  end


  describe "#configuration" do
    context "when we are working with SNMP V2" do
      it "returns a Configuration for SNMP V2" do
        expect(described_class.new(Snmpjr::Version::V2C).configuration).to be_a(Snmpjr::ConfigurationV2C)
      end
    end

    context "when we are working with SNMP V3" do
      it "returns a Configuration for SNMP V3" do
        expect(described_class.new(Snmpjr::Version::V3).configuration).to be_a(Snmpjr::ConfigurationV3)
      end
    end
  end

  describe "#configure" do
    context "when we are working with SNMP V2" do
      it "yields an Snmpjr V2C configuration" do
        expect {|block|
          Snmpjr.new(Snmpjr::Version::V2C).configure(&block)
        }.to yield_control
        Snmpjr.new(Snmpjr::Version::V2C).configure do |config|
          expect(config).to be_a(Snmpjr::ConfigurationV2C)
        end
      end
    end

    context "when we are working with SNMP V3" do
      it "yields an Snmpjr V3 configuration" do
        expect {|block|
          Snmpjr.new(Snmpjr::Version::V3).configure(&block)
        }.to yield_control
        Snmpjr.new(Snmpjr::Version::V3).configure do |config|
          expect(config).to be_a(Snmpjr::ConfigurationV3)
        end
      end
    end
  end

  let(:pdu_factory) { double :pdu_factory }

  describe "#get" do
    let(:getter) { double Snmpjr::Getter }

    before do
      allow(Snmpjr::ConfigurationV2C).to receive(:new).and_return configuration
      allow(Snmpjr::ConfigurationV3).to receive(:new).and_return configuration
      allow(Snmpjr::Getter).to receive(:new).with(target: created_target, pdu: pdu_factory, config: configuration).and_return getter
      allow(Snmpjr::PduV2C).to receive(:new).and_return pdu_factory
      allow(Snmpjr::PduV3).to receive(:new).and_return pdu_factory
      allow(getter).to receive(:get)
    end

    context 'when working with SNMPV2C' do
      subject { described_class.new(Snmpjr::Version::V2C) }
      it 'passes a PduV2C to the getter' do
        expect(Snmpjr::Getter).to receive(:new).with(target: created_target, pdu: pdu_factory, config: configuration)
        subject.get '1.2.3.4.5.6'
      end
    end

    context 'when working with SNMPV3' do
      subject { described_class.new(Snmpjr::Version::V3) }

      it 'passes a PduV3 to the getter' do
        expect(Snmpjr::Getter).to receive(:new).with(target: created_target, pdu: pdu_factory, config: configuration)
        subject.get '1.2.3.4.5.6'
      end
    end


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
      allow(Snmpjr::Walker).to receive(:new).with(target: created_target, pdu: pdu_factory).and_return walker
      allow(Snmpjr::Wrappers::SMI::OID).to receive(:new).with('1.3.6.1.1').and_return oid
      allow(Snmpjr::PduV3).to receive(:new).and_return pdu_factory
      allow(Snmpjr::PduV2C).to receive(:new).and_return pdu_factory
      allow(walker).to receive(:walk)
    end

    context 'when working with SNMPV2' do
      it 'passes a PduV2 to the walker' do
        expect(Snmpjr::Walker).to receive(:new).with(target: created_target, pdu: pdu_factory)
        subject.walk '1.3.6.1.1'
      end
    end

    context 'when working with SNMPV3' do
      it 'passes a PduV3 to the walker' do
        expect(Snmpjr::Walker).to receive(:new).with(target: created_target, pdu: pdu_factory)
        subject.walk '1.3.6.1.1'
      end
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
