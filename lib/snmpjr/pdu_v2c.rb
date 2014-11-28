require 'snmpjr/wrappers/smi'
require 'snmpjr/wrappers/snmp4j'

class Snmpjr
  class PduV2C
    module Constants
      GET = -96
    end

    def initialize
      @pdu = Snmpjr::Wrappers::PDU.new
    end

    def create oids
      oids.map {|oid|
        oid = Snmpjr::Wrappers::SMI::OID.new oid
        variable_binding = Snmpjr::Wrappers::SMI::VariableBinding.new oid
        @pdu.add variable_binding
      }
      @pdu.type = Snmpjr::PduV2C::Constants::GET
      @pdu
    end

  end
end
