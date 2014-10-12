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

  def get oids
    target = Snmpjr::Target.new.create(:host => @host, :port => @port, :community => @community)

    case oids.class.to_s
    when 'String'
      get_oid(oids, target)
    when 'Array'
      oids.map{|oid|
        get_oid(oid, target)
      }
    else
      raise ArgumentError.new 'You can request a single Oid using a String, or multiple using an Array'
    end
  end

  private

  def get_oid oid, target
    pdu = Snmpjr::Pdu.new.create oid
    Snmpjr::Session.new.send(pdu, target)
  end

end
