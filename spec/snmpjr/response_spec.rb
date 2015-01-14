require production_code

describe Snmpjr::Response do
  describe '#to_s' do
    it 'returns the value' do
      response = described_class.new(oid: 'some oid', value: 'Some value')
      expect(response.to_s).to eq 'Some value'
    end
  end

  describe '#oid' do
    it 'returns the oid' do
      response = described_class.new(oid: 'some oid', value: 'Some error')
      expect(response.oid).to eq 'some oid'
    end
  end

  describe '#==' do
    context 'when the objects are equal' do
      let(:other) { Snmpjr::Response.new(oid: 'some oid', value: 'some value') }
      it 'returns true' do
        expect(described_class.new(oid: 'some oid', value: 'some value')).to eq other
      end
    end

    context 'when the objects are not equal' do
      let(:other) { Snmpjr::Response.new(oid: 'some oid', value: 'some value') }
      it 'returns true' do
        expect(described_class.new(oid: 'some oid', value: 'another value')).to_not eq other
      end
    end

    context 'when the oids are different' do
      let(:other) { Snmpjr::Response.new(oid: 'some oid', value: 'some value') }
      it 'returns true' do
        expect(described_class.new(oid: 'another oid', value: 'some value')).to_not eq other
      end
    end

    context 'when the objects are not of the same class' do
      let(:other) { double :response }
      before do
        allow(other).to receive(:error).and_return ''
        allow(other).to receive(:to_s).and_return 'some value'
        allow(other).to receive(:oid).and_return 'some oid'
      end

      it 'returns false' do
        expect(described_class.new(oid: 'some oid', value: 'some value')).to_not eq other
      end
    end
  end
end
