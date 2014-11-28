require 'snmpjr/session_v2c'
require 'snmpjr/wrappers/security'
require 'snmpjr/wrappers/smi'
require 'snmpjr/wrappers/mp'

class Snmpjr
  class SessionV3 < Snmpjr::SessionV2C
    AUTHENTICATION_PROTOCOLS = {
      'MD5' => Snmpjr::Wrappers::Security::AuthMD5,
      'SHA' => Snmpjr::Wrappers::Security::AuthSHA
    }

    PRIVACY_PROTOCOLS = {
      '3DES' => Snmpjr::Wrappers::Security::Priv3DES,
      'DES' => Snmpjr::Wrappers::Security::PrivDES,
      'AES128' => Snmpjr::Wrappers::Security::PrivAES128,
      'AES192' => Snmpjr::Wrappers::Security::PrivAES192,
      'AES256' => Snmpjr::Wrappers::Security::PrivAES256
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
        AUTHENTICATION_PROTOCOLS.fetch(@config.authentication_protocol).const_get(:ID),
        Snmpjr::Wrappers::SMI::OctetString.new(@config.authentication_key),
        PRIVACY_PROTOCOLS.fetch(@config.privacy_protocol).const_get(:ID),
        Snmpjr::Wrappers::SMI::OctetString.new(@config.privacy_key)
      )
    end
  end
end
