require 'snmpjr/wrappers/transport'
require 'snmpjr/response'

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
          Snmpjr::Response.new(:error => 'Request timed out')
        else
          Snmpjr::Response.new(:value => result.response.variable_bindings.first.variable.to_s)
        end
      rescue Exception => error
        Snmpjr::Response.new(:error => error.to_s)
      end
    end

    def close
      @snmp.close
    end
  end
end
