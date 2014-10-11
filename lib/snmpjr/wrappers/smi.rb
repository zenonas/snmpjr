require 'snmpjr/wrappers/snmp4j'

class Snmpjr
  module Wrappers
    module SMI
      include_package 'org.snmp4j.smi'
    end
  end
end
