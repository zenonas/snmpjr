require "snmpjr/version"
require "snmpjr/getter"
require "snmpjr/target"

class Snmpjr

  def initialize options = {}
    @host = options.fetch(:host)
    @port = options.fetch(:port) { 161 }
    @community = options.fetch(:community)
    @timeout = options.fetch(:timeout) { 5000 }
    @max_oids_per_request = options.fetch(:max_oids_per_request) { 30 }
    @retries = options.fetch(:retries) { 0 }
  end

  def get oids
    target = Snmpjr::Target.new.create(host: @host,
                                       port: @port,
                                       community: @community,
                                       timeout: @timeout,
                                       retries: @retries
                                      )
    getter = Snmpjr::Getter.new(target: target, max_oids_per_request: @max_oids_per_request)

    if oids.is_a?(String)
      getter.get oids
    elsif oids.is_a?(Array)
      getter.get_multiple oids
    else
      raise ArgumentError.new 'You can request a single Oid using a String, or multiple using an Array'
    end
  end

end
