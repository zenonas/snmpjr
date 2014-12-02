require 'snmpjr/pdu_v2c'
require 'snmpjr/wrappers/snmp4j'
require 'snmpjr/wrappers/smi'

class Snmpjr
  class PduV3 < Snmpjr::PduV2C

    def initialize context = ''
      @context_name = Snmpjr::Wrappers::SMI::OctetString.new(context)
    end

    private

    def create_new_pdu
      pdu = Snmpjr::Wrappers::ScopedPDU.new
      pdu.context_name = @context_name
      pdu
    end

  end
end
