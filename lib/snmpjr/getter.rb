require "snmpjr/pdu"
require "snmpjr/session"

class Snmpjr
  class Getter

    def initialize target
      @target = target
      @session = Snmpjr::Session.new
    end

    def get_multiple oids
      @session.start
      oids.map {|oid|
        send_oid oid
      }
      @session.close
    end

    def get oid
      @session.start
      send_oid oid
      @session.close
    end

    private

    def send_oid oid
      pdu = Snmpjr::Pdu.new.create oid
      @session.send(pdu, @target)
    end

  end
end
