require 'snmpjr/configuration_v2c'
require 'snmpjr/configuration_v3'
require 'snmpjr/wrappers/smi'
require "snmpjr/getter"
require 'snmpjr/walker'
require 'snmpjr/version'

class Snmpjr

  CONFIGURATION_VERSION = {
    Snmpjr::Version::V2C => Snmpjr::ConfigurationV2C,
    Snmpjr::Version::V3 => Snmpjr::ConfigurationV3
  }

  def initialize version
    @version = version
  end

  def configuration
    @configuration ||= CONFIGURATION_VERSION.fetch(@version).new
  end

  def configure
    yield(configuration) if block_given?
    self
  end

  def get oids
    Snmpjr::Getter.new(
      session: configuration.create_session,
      target: configuration.create_target,
      pdu: configuration.create_pdu,
      config: configuration
    ).get Array(oids)
  end

  def walk oid
    Snmpjr::Walker.new(
      session: configuration.create_session,
      target: configuration.create_target,
      pdu: configuration.create_pdu
    ).walk Snmpjr::Wrappers::SMI::OID.new(oid.to_s)
  end
end
