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
    target = Snmpjr::Target.new.create(:host => @host, :port => @port, :community => @community)
    pdu = Snmpjr::Pdu.new.create oid
    Snmpjr::Session.new.send(pdu, target)
  end

end
