require 'snmpjr/session_v2c'
require 'snmpjr/wrappers/security'
require 'snmpjr/wrappers/smi'
require 'snmpjr/wrappers/mp'

class Snmpjr
  class SessionV3 < Snmpjr::SessionV2C
    AUTHENTICATION_PROTOCOLS = {
      'MD5' => Snmpjr::Wrappers::Security::AuthMD5::ID,
      'SHA' => Snmpjr::Wrappers::Security::AuthSHA::ID
    }

    PRIVACY_PROTOCOLS = {
      '3DES' => Snmpjr::Wrappers::Security::Priv3DES::ID,
      'DES' => Snmpjr::Wrappers::Security::PrivDES::ID,
      'AES128' => Snmpjr::Wrappers::Security::PrivAES128::ID,
      'AES192' => Snmpjr::Wrappers::Security::PrivAES192::ID,
      'AES256' => Snmpjr::Wrappers::Security::PrivAES256::ID
    }

    def initialize configuration
      @snmp = Snmpjr::Wrappers::Snmp.new(Snmpjr::Wrappers::Transport::DefaultUdpTransportMapping.new)
      @config = configuration
      add_v3_security
    end

    private

    def add_v3_security
      create_and_attach_usm
      @snmp.usm.add_user create_usm_user
    end

    def create_and_attach_usm
      usm = Snmpjr::Wrappers::Security::USM.new(
        Snmpjr::Wrappers::Security::SecurityProtocols.instance,
        Snmpjr::Wrappers::SMI::OctetString.new(Snmpjr::Wrappers::MP::MPv3.create_local_engine_id),
        0
      )
      Snmpjr::Wrappers::Security::SecurityModels.instance.add_security_model usm
    end

    def create_usm_user
      Snmpjr::Wrappers::Security::UsmUser.new(
        Snmpjr::Wrappers::SMI::OctetString.new(@config.user),
        AUTHENTICATION_PROTOCOLS[@config.authentication_protocol],
        authentication_key,
        PRIVACY_PROTOCOLS[@config.privacy_protocol],
        privacy_key
      )
    end

    def authentication_key
      return @config.authentication_key if @config.authentication_key.nil?
      Snmpjr::Wrappers::SMI::OctetString.new(@config.authentication_key)
    end

    def privacy_key
      return @config.privacy_key if @config.privacy_key.nil?
      Snmpjr::Wrappers::SMI::OctetString.new(@config.privacy_key)
    end
  end
end
