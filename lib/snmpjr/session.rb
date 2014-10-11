require 'snmpjr/wrappers/transport'

class Snmpjr
  class Session


    def send pdu, target
      snmp = Snmpjr::Wrappers::Snmp.new(Snmpjr::Wrappers::Transport::DefaultUdpTransportMapping.new)
      snmp.listen

      begin
        result = snmp.send(pdu, target)
      rescue
        raise "Failed to send SNMP package"
      ensure
        snmp.close
      end

      result.response.variable_bindings.first.variable.to_s
    end
  end
end
