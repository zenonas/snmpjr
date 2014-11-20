class Snmpjr
  class ConfigurationV2C
    attr_accessor :host, :port, :community, :retries, :timeout, :max_oids_per_request

    def initialize
      @retries = 0
      @timeout = 5000
      @max_oids_per_request = 20
    end
  end
end
