class Snmpjr
  class Configuration
    attr_accessor :host, :port, :retries, :timeout, :max_oids_per_request

    def initialize
      @port = 161
      @retries = 0
      @timeout = 5000
      @max_oids_per_request = 20
    end

  end
end
