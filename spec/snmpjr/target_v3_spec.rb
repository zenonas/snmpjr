require 'snmpjr/configuration_v3'
require production_code

describe Snmpjr::TargetV3 do

  describe '#create' do
    let(:configuration) do
      config = Snmpjr::ConfigurationV3.new
      config.host = '127.0.0.1'
      config.port = 161
      config.retries = 2
      config.context = '80004fb805636c6f75644dab22cc'
      config.user = 'username'
      config.authentication 'SHA', 'authkey1'
      config.privacy 'DES', 'privkey1'
      config.timeout = 50
      config
    end

    it 'returns the SNMP4J user target' do
      expect(subject.create(configuration)).to be_a(Snmpjr::Wrappers::UserTarget)
    end

    let(:target) { subject.create(configuration) }

    specify 'the user target has the correct host and port' do
      expect(target.address.to_s).to eq('127.0.0.1/161')
    end

    specify 'the user target has the correct retries' do
      expect(target.retries).to eq 2
    end

    specify 'the user target has the correct timeout' do
      expect(target.timeout).to eq 50
    end

    specify 'the user was created with the correct user' do
      expect(target.security_name.to_s).to eq 'username'
    end

    it 'sets the snmp version to 3' do
      expect(target.version).to eq Snmpjr::Version::V3
    end

    it 'sets the security level' do
      expect(target.security_level).to eq Snmpjr::ConfigurationV3::SecurityLevels::AuthPriv
    end
  end
end
