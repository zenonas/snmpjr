require 'snmpjr/configuration'
require 'snmpjr/target_v3'
require 'snmpjr/session_v3'
require 'snmpjr/pdu_v3'

class Snmpjr
  class ConfigurationV3 < Configuration
    module SecurityLevels
      NoAuthNoPriv = 1
      AuthNoPriv = 2
      AuthPriv = 3
    end

    attr_accessor :context, :user
    attr_reader :authentication_protocol, :authentication_key,  :privacy_protocol, :privacy_key

    def initialize
      @context = ''
      super
    end

    def security_level
      return SecurityLevels::AuthPriv if authentication_protocol && privacy_protocol
      return SecurityLevels::AuthNoPriv if authentication_protocol
      SecurityLevels::NoAuthNoPriv
    end

    def authentication protocol, key
      @authentication_protocol = protocol
      @authentication_key = key
    end

    def privacy protocol, key
      @privacy_protocol = protocol
      @privacy_key = key
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
