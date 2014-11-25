require production_code

describe Snmpjr::PduV2C do
  describe '#create' do
    it 'creates a PDU object' do
      expect(subject.create ['1.3.6']).to be_a(Snmpjr::Wrappers::PDU)
    end
  end
end
