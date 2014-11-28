require production_code

describe Snmpjr do
  let(:target) { double :target }
  let(:configuration) { double :configuration }
  let(:created_target) { double :created_target }
  let(:created_pdu) { double :created_pdu }
  let(:created_session) { double :created_session }

  subject { described_class.new(Snmpjr::Version::V2C) }

  before do
    allow(configuration).to receive(:create_target).and_return created_target
    allow(configuration).to receive(:create_pdu).and_return created_pdu
    allow(configuration).to receive(:create_session).and_return created_session
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

    it 'returns an instance of Snmpjr' do
      result = Snmpjr.new(Snmpjr::Version::V3).configure do |config|
        config.user = 'some_user'
      end
      expect(result).to be_a(Snmpjr)
    end
  end

  describe "#get" do
    let(:getter) { double Snmpjr::Getter }

    before do
      allow(Snmpjr::ConfigurationV2C).to receive(:new).and_return configuration
      allow(Snmpjr::ConfigurationV3).to receive(:new).and_return configuration
      allow(Snmpjr::Getter).to receive(:new).with(session: created_session, target: created_target, pdu: created_pdu, config: configuration).and_return getter
      allow(getter).to receive(:get)
    end

    context 'when passed a single oid' do
      it 'coerces the single oid to an array and gives it to the getter' do
        expect(getter).to receive(:get).with(['1.2.3.4.5.6'])
        subject.get '1.2.3.4.5.6'
      end
    end

    context 'when passed multiple oids' do
      it 'performs a get with the getter' do
        expect(getter).to receive(:get).with(['1.2.3.4.5.6', '6.5.4.3.2.1'])
        subject.get ['1.2.3.4.5.6', '6.5.4.3.2.1']
      end
    end
  end

  describe '#walk' do
    let(:walker) { double Snmpjr::Walker }
    let(:oid) { double :oid }

    before do
      allow(Snmpjr::ConfigurationV2C).to receive(:new).and_return configuration
      allow(Snmpjr::Walker).to receive(:new).with(session: created_session, target: created_target, pdu: created_pdu).and_return walker
      allow(Snmpjr::Wrappers::SMI::OID).to receive(:new).with('1.3.6.1.1').and_return oid
      allow(walker).to receive(:walk)
    end

    it 'performs a synchronous walk' do
      expect(walker).to receive(:walk).with(oid)
      subject.walk '1.3.6.1.1'
    end
  end
end
