require production_code

describe Snmpjr::Response do

  describe '.new' do
    context 'when initialized with a value' do
      it 'assigns that value' do
        response = described_class.new(oid: 'some oid', value: 'Some value', type: 'Some type')
        expect(response.to_h).to eq({ oid: 'some oid', value: 'Some value', type: 'Some type' })
      end

      it 'sets the error to an empty string' do
        response = described_class.new(oid: 'some oid', value: 'Some value', type: 'Some type')
        expect(response.error).to eq ''
      end
    end

    context 'when initialized with an error' do
      it 'assigns that error' do
        response = described_class.new(oid: 'some oid', error: 'Some error')
        expect(response.error).to eq 'Some error'
      end

      it 'sets the value to an empty string' do
        response = described_class.new(oid: 'some oid', error: 'Some error')
        expect(response.to_s).to eq ''
      end
    end
  end

  describe '#oid' do
    it 'returns the oid' do
      response = described_class.new(oid: 'some oid', error: 'Some error')
      expect(response.oid).to eq 'some oid'
    end
  end

  describe '#error?' do
    it 'returns true if there is an error' do
      response = described_class.new(oid: 'some oid', error: 'Some error')
      expect(response.error?).to be_truthy
    end

    it 'returns false if there isnt an error' do
      response = described_class.new(oid: 'some oid', value: 'Some value', type: 'Some type')
      expect(response.error?).to be_falsey
    end
  end

  describe '#==' do
    context 'when the objects are equal' do
      let(:other) { Snmpjr::Response.new(oid: 'some oid', value: 'some value', type: 'Some type') }
      it 'returns true' do
        expect(described_class.new(oid: 'some oid', value: 'some value', type: 'Some type')).to eq other
      end
    end

    context 'when the objects are different' do
      context 'when the objects are equal' do
        let(:other) { Snmpjr::Response.new(oid: 'some oid', error: 'some error') }
        it 'returns false' do
          expect(described_class.new(oid: 'some oid', error: 'another error')).to_not eq other
        end
      end
    end

    context 'when the objects are not of the same class' do
      let(:other) { double :response }
      before do
        allow(other).to receive(:error).and_return ''
        allow(other).to receive(:to_h).and_return({ value: 'some value', type: 'Some type' })
        allow(other).to receive(:oid).and_return 'some oid'
      end

      it 'returns false' do
        expect(described_class.new(oid: 'some oid', value: 'some value', type: 'Some type')).to_not eq other
      end
    end
  end
end
