require 'snmpjr/session'

class Snmpjr
  class SessionV3 < Snmpjr::Session

    def initialize
      @snmp = Snmpjr::Wrappers::Snmp.new(Snmpjr::Wrappers::Transport::DefaultUdpTransportMapping.new)
    end

  end
end
