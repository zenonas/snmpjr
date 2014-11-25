require 'snmpjr/wrappers/snmp4j'

class Snmpjr
  module Wrappers
    module Security
      include_package 'org.snmp4j.security'
    end
  end
end
