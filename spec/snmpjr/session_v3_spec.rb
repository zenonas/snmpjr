require production_code
require 'snmpjr/configuration_v3'

describe Snmpjr::SessionV3 do
  describe '.new' do
    it 'creates and attaches the correct user security model (usm)' do
      config = Snmpjr::ConfigurationV3.new
      config.host = 'demo.snmplabs.com'
      config.port = 161
      config.user = 'usr-sha-des'
      config.security_level = 'authPriv'
      config.authentication_protocol = 'SHA'
      config.authentication_key = 'authkey1'
      config.privacy_protocol = 'DES'
      config.privacy_key = 'privkey1'

      session = described_class.new config

      expect(session.snmp.usm.user_table.user_entries.first.usm_user.security_name.to_s).to eq 'usr-sha-des'
      expect(session.snmp.usm.user_table.user_entries.first.usm_user.privacy_passphrase.to_s).to eq 'privkey1'
      expect(session.snmp.usm.user_table.user_entries.first.usm_user.authentication_passphrase.to_s).to eq 'authkey1'

    end
  end
end
