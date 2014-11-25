require 'snmpjr/pdu'
require 'snmpjr/wrappers/snmp4j'

class Snmpjr
  class PduV2C < Snmpjr::Pdu
    def initialize
      @pdu = Snmpjr::Wrappers::PDU.new
    end
  end
end
