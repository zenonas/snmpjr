require 'snmpjr/configuration_v2c'
require 'snmpjr/wrappers/smi'
require "snmpjr/getter"
require 'snmpjr/walker'
require 'snmpjr/version'
require "snmpjr/target"

class Snmpjr
  def initialize version

  end

  def configuration
    @configuration ||= Snmpjr::ConfigurationV2C.new
  end

  def configure
    yield(configuration) if block_given?
  end

  def get oids
    getter = Snmpjr::Getter.new(target: target, config: configuration)

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
      Snmpjr::Walker.new(target: target).walk Snmpjr::Wrappers::SMI::OID.new(oid)
    else
      raise ArgumentError.new 'The oid needs to be passed in as a String'
    end
  end


  private

  def target
    Snmpjr::Target.new.create(configuration)
  end
end
