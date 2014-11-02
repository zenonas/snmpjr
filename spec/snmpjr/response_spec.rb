require production_code

describe Snmpjr::Response do

  describe '.new' do
    context 'when initialized with a value' do
      it 'assigns that value' do
        response = described_class.new(value: 'Some value')
        expect(response.to_s).to eq 'Some value'
      end

      it 'sets the error to an empty string' do
        response = described_class.new(value: 'Some value')
        expect(response.error).to eq ''
      end
    end

    context 'when initialized with an error' do
      it 'assigns that error' do
        response = described_class.new(error: 'Some error')
        expect(response.error).to eq 'Some error'
      end

      it 'sets the value to an empty string' do
        response = described_class.new(error: 'Some error')
        expect(response.to_s).to eq ''
      end
    end
  end

  describe '#error?' do
    it 'returns true if there is an error' do
      response = described_class.new(error: 'Some error')
      expect(response.error?).to be_truthy
    end

    it 'returns false if there isnt an error' do
      response = described_class.new(value: 'Some value')
      expect(response.error?).to be_falsey
    end
  end

  describe '#==' do
    context 'when the objects are equal' do
      let(:other) { Snmpjr::Response.new(value: 'some value') }
      it 'returns true' do
        expect(described_class.new(value: 'some value')).to eq other
      end
    end

    context 'when the objects are not equal' do
      let(:other) { Snmpjr::Response.new(error: 'some value') }
      it 'returns true' do
        expect(described_class.new(error: 'some error')).to_not eq other
      end
    end

    context 'when the objects are not of the same class' do
      let(:other) { double :response }
      before do
        allow(other).to receive(:error).and_return ''
        allow(other).to receive(:to_s).and_return 'some value'
      end

      it 'returns false' do
        expect(described_class.new(value: 'some value')).to_not eq other
      end
    end
  end
end
