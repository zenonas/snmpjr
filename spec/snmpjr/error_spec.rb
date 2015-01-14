require production_code

describe Snmpjr::Error do

  describe '#to_h' do
    it 'returns the error response in a hash' do
      response = described_class.new(oid: 'some oid', error: 'Some error')
      expect(response.to_h).to eq({ oid: 'some oid', error: 'Some error' })
    end
  end

  describe '#oid' do
    it 'returns the oid' do
      response = described_class.new(oid: 'some oid', error: 'Some error')
      expect(response.oid).to eq 'some oid'
    end
  end

  describe '#==' do
    context 'when the objects are equal' do
      let(:other) { described_class.new(oid: 'some oid', error: 'some error') }
      it 'returns true' do
        expect(described_class.new(oid: 'some oid', error: 'some error')).to eq other
      end
    end

    context 'when the objects are not equal' do
      let(:other) { described_class.new(oid: 'some oid', error: 'some error') }
      it 'returns false' do
        expect(described_class.new(oid: 'some oid', error: 'another error')).to_not eq other
      end
    end

    context 'when the objects are not of the same class' do
      let(:other) { double :response }
      before do
        allow(other).to receive(:to_h).and_return({ oid: 'some oid', value: 'some value' })
      end

      it 'returns false' do
        expect(described_class.new(oid: 'some oid', value: 'some value')).to_not eq other
      end
    end
  end
end
