require 'snmpjr/wrappers/transport'
require 'snmpjr/response'

class Snmpjr
  class SessionV2C
    attr_reader :snmp

    def initialize
      @snmp = Snmpjr::Wrappers::Snmp.new(Snmpjr::Wrappers::Transport::DefaultUdpTransportMapping.new)
    end

    def start
      @snmp.listen
    end

    def send pdu, target
      begin
        result = @snmp.send(pdu, target)
      rescue Exception => error
        raise RuntimeError.new(error)
      end
      if result.response.nil?
        raise Snmpjr::TargetTimeoutError.new('Request timed out')
      else
        result.response.variable_bindings.map{|vb|
          construct_response(vb)
        }
      end
    end

    def close
      @snmp.close
    end

    private

    def construct_response variable_binding
      if variable_binding.is_exception
        Snmpjr::Response.new(oid: variable_binding.oid.to_s, error: variable_binding.variable.to_s)
      else
        Snmpjr::Response.new(oid: variable_binding.oid.to_s, value: variable_binding.variable.to_s)
      end
    end

  end

  class TargetTimeoutError < StandardError
  end
end
