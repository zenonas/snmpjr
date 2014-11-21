require 'snmpjr/wrappers/smi'
require 'snmpjr/target_v2c'
require 'snmpjr/target_v3'
require 'snmpjr/configuration_v2c'
require 'snmpjr/configuration_v3'

class Snmpjr
  class Target
    POSSIBLE_TARGETS = {
      Snmpjr::ConfigurationV2C => Snmpjr::TargetV2C,
      Snmpjr::ConfigurationV3 => Snmpjr::TargetV3
    }

    def create(configuration)
      POSSIBLE_TARGETS.fetch(configuration.class).new.create(configuration)
    end
  end
end
