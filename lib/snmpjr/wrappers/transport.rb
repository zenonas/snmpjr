require 'snmpjr/wrappers/snmp4j'

class Snmpjr
  module Wrappers
    module Transport
      include_package 'org.snmp4j.transport'
    end
  end
end
