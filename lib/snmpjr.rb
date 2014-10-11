require "snmpjr/version"
require "snmpjr/pdu"
require "snmpjr/session"
require "snmpjr/target"

class Snmpjr

  def initialize options = {}
    @host = options.fetch(:host)
    @port = options.fetch(:port) || 161
    @community = options.fetch(:community)
  end

  def get oid
    target = Snmpjr::Target.new(:host => @host, :port => @port, :community => @community)
    pdu = Snmpjr::Pdu.new oid
    Snmpjr::Session.new.send target, pdu
  end

end
