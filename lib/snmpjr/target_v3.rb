require 'snmpjr/wrappers/snmp4j'
require 'snmpjr/wrappers/smi'
require 'snmpjr/version'

class Snmpjr
  class TargetV3

    def create configuration
      target = Snmpjr::Wrappers::UserTarget.new
      target.address = Snmpjr::Wrappers::SMI::GenericAddress.parse("udp:#{configuration.host}/#{configuration.port}")
      target.security_name = Snmpjr::Wrappers::SMI::OctetString.new(configuration.user)
      target.version = Snmpjr::Version::V3
      target.retries = configuration.retries
      target.timeout = configuration.timeout
      target.security_level = configuration.security_level
      target
    end
  end
end
