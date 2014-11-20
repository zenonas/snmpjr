require production_code
require 'snmpjr/configuration_v2c'

describe Snmpjr::Target do

  describe '#create' do
    let(:configuration) do
      config = Snmpjr::ConfigurationV2C.new
      config.host = '127.0.0.1'
      config.port = 161
      config.community = 'some community'
      config.retries = 2
      config.timeout = 50
      config
    end

    context 'when given a version 2 config' do
      it 'returns a V2C Target' do
        expect(Snmpjr::Target.new.create(configuration)).to be_a(Snmpjr::Wrappers::CommunityTarget)
      end
    end
  end
end
