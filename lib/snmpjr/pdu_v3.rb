require 'snmpjr/pdu'
require 'snmpjr/wrappers/snmp4j'
require 'snmpjr/wrappers/smi'

class Snmpjr
  class PduV3 < Snmpjr::Pdu

    def initialize context
      @pdu = Snmpjr::Wrappers::ScopedPDU.new
      @pdu.context_name = Snmpjr::Wrappers::SMI::OctetString.new(context)
    end

  end
end
