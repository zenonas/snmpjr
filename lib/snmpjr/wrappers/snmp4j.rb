module Wrappers
  begin
    require 'java'
    require 'snmpjr/wrappers/snmp4j-2.3.1.jar'
  rescue
    raise "Snmpjr requires JRuby"
  end
end
