require 'snmpjr/wrappers/smi'
require 'snmpjr/target_v2c'

class Snmpjr
  class Target
    def create(configuration)
      Snmpjr::TargetV2C.new.create(configuration)
    end
  end
end
