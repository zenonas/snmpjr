require 'snmpjr/wrappers/smi'
require 'snmpjr/wrappers/snmp4j'

class Snmpjr
  class Pdu
    module Constants
      GET = -96
    end

    def create oids
      pdu = Snmpjr::Wrappers::PDU.new
      oids.map {|oid|
        oid = Snmpjr::Wrappers::SMI::OID.new oid
        variable_binding = Snmpjr::Wrappers::SMI::VariableBinding.new oid
        pdu.add variable_binding
      }
      pdu.type = Snmpjr::Pdu::Constants::GET
      pdu
    end

    def self.createPDU target
      Snmpjr::Wrappers::PDU.new
    end

  end
end
