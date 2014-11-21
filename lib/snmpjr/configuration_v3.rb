require 'snmpjr/configuration'

class Snmpjr
  class ConfigurationV3 < Configuration
    attr_accessor :context, :user, :security_level, :authentication_protocol, :authentication_key, :privacy_protocol, :privacy_key

    def initialize
      @context = ''
      super
    end

  end
end
