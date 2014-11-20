require "snmpjr/configuration_v2c"
require "snmpjr/version"
require 'snmpjr/wrappers/smi'
require "snmpjr/getter"
require "snmpjr/walker"
require "snmpjr/target"

class Snmpjr
  module Version
    V2C = 1
    V3 = 3
  end

  def initialize version
    #@host = options.fetch(:host)
    #@port = options.fetch(:port) { 161 }
    #@community = options.fetch(:community)
    #@timeout = options.fetch(:timeout) { 5000 }
    #@retries = options.fetch(:retries) { 0 }

    @target = Snmpjr::Target.new.create(configuration)
    #@max_oids_per_request = options.fetch(:max_oids_per_request) { 30 }
  end

  def configuration
    @configuration ||= Snmpjr::ConfigurationV2C.new
  end

  def configure
    yield(configuration) if block_given?
  end

  def get oids
    getter = Snmpjr::Getter.new(target: @target, config: configuration)

    if oids.is_a?(String)
      getter.get oids
    elsif oids.is_a?(Array)
      getter.get_multiple oids
    else
      raise ArgumentError.new 'You can request a single Oid using a String, or multiple using an Array'
    end
  end

  def walk oid
    if oid.is_a?(String)
      Snmpjr::Walker.new(target: @target).walk Snmpjr::Wrappers::SMI::OID.new(oid)
    else
      raise ArgumentError.new 'The oid needs to be passed in as a String'
    end
  end

end
