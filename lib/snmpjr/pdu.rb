class Snmpjr
  class Pdu
    module Constants
      GET = -96
    end

    def create oid
      pdu = Snmpjr::Wrappers::PDU.new
      oid = Snmpjr::Wrappers::SMI::OID.new oid
      variable_binding = Snmpjr::Wrappers::SMI::VariableBinding.new oid
      pdu.add variable_binding
      pdu.type = Snmpjr::Pdu::Constants::GET
      pdu
    end

  end
end
