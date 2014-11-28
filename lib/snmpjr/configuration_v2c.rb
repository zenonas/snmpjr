require 'snmpjr/configuration'
require 'snmpjr/pdu_v2c'
require 'snmpjr/target_v2c'
require 'snmpjr/session_v2c'

class Snmpjr
  class ConfigurationV2C < Configuration
    attr_accessor :community

    def create_pdu
      Snmpjr::PduV2C.new
    end

    def create_target
      Snmpjr::TargetV2C.new.create self
    end

    def create_session
      Snmpjr::SessionV2C.new
    end
  end
end
