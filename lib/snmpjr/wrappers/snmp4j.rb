class Snmpjr
  module Wrappers
    require 'java'
    require 'snmpjr/wrappers/snmp4j-2.3.1.jar'

    include_package 'org.snmp4j'
  end
end
