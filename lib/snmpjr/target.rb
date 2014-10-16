require 'snmpjr/wrappers/smi'

class Snmpjr
  class Target

    def create options = {}
      target = Snmpjr::Wrappers::CommunityTarget.new
      target.community = Snmpjr::Wrappers::SMI::OctetString.new(options.fetch(:community))
      target.address = Snmpjr::Wrappers::SMI::GenericAddress.parse("udp:#{options.fetch(:host)}/#{options.fetch(:port)}")
      target.version = 1
      target.retries = options.fetch(:retries)
      target.timeout = options.fetch(:timeout)
      target
    end

  end
end
