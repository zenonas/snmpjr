require 'snmpjr/wrappers/transport'

class Snmpjr
  class Session

    def initialize
      @snmp = Snmpjr::Wrappers::Snmp.new(Snmpjr::Wrappers::Transport::DefaultUdpTransportMapping.new)
    end

    def start
      @snmp.listen
    end

    def send pdu, target
      begin
        result = @snmp.send(pdu, target)
        if result.response.nil?
          "Request timed out"
        else
          result.response.variable_bindings.first.variable.to_s
        end
      rescue Exception => e
        "Error: #{e.to_s}"
      end
    end

    def close
      @snmp.close
    end
  end
end
