require 'snmpjr/wrappers/smi'
require 'snmpjr/wrappers/snmp4j'

class Snmpjr
  class Pdu
    module Constants
      GET = -96
    end

    def initialize
      raise NotImplementedError.new('You cannot use the Pdu object on its own, use PduV2C or PduV3')
    end

    def create oids
      oids.map {|oid|
        oid = Snmpjr::Wrappers::SMI::OID.new oid
        variable_binding = Snmpjr::Wrappers::SMI::VariableBinding.new oid
        @pdu.add variable_binding
      }
      @pdu.type = Snmpjr::Pdu::Constants::GET
      @pdu
    end

  end
end
