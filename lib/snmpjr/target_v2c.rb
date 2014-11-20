require 'snmpjr/wrappers/smi'
require 'snmpjr/version'

class Snmpjr
  class TargetV2C

    def create configuration
      target = Snmpjr::Wrappers::CommunityTarget.new
      target.community = Snmpjr::Wrappers::SMI::OctetString.new(configuration.community)
      target.address = Snmpjr::Wrappers::SMI::GenericAddress.parse("udp:#{configuration.host}/#{configuration.port}")
      target.version = Snmpjr::Version::V2C
      target.retries = configuration.retries
      target.timeout = configuration.timeout
      target
    end

  end
end
