require 'snmpjr/configuration'
require 'snmpjr/target_v3'
require 'snmpjr/session_v3'
require 'snmpjr/pdu_v3'

class Snmpjr
  class ConfigurationV3 < Configuration
    attr_accessor :context, :user, :security_level, :authentication_protocol, :authentication_key, :privacy_protocol, :privacy_key

    def initialize
      @context = ''
      super
    end

    def create_target
      Snmpjr::TargetV3.new.create self
    end

    def create_session
      Snmpjr::SessionV3.new self
    end

    def create_pdu
      Snmpjr::PduV3.new context
    end

  end
end
