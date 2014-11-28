require 'snmpjr/pdu_v2c'
require 'snmpjr/wrappers/snmp4j'
require 'snmpjr/wrappers/smi'

class Snmpjr
  class PduV3 < Snmpjr::PduV2C

    def initialize context = ''
      @pdu = Snmpjr::Wrappers::ScopedPDU.new
      @pdu.context_name = Snmpjr::Wrappers::SMI::OctetString.new(context)
    end

  end
end
