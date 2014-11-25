require production_code

describe Snmpjr::PduV3 do
  subject { Snmpjr::PduV3.new 'context' }

  describe '.new' do
    it 'assigns scoped context name' do
      expect(subject.create(['1.3.6']).context_name.to_s).to eq 'context'
    end
  end

  describe '#create' do
    it 'creates a scoped Pdu' do
      expect(subject.create ['1.3.6']).to be_a(Snmpjr::Wrappers::ScopedPDU)
    end
  end
end
