require "snmpjr/pdu"
require "snmpjr/session"

class Snmpjr
  class Getter

    def initialize args = {}
      @target = args.fetch(:target)
      @max_oids_per_request = args.fetch(:config).max_oids_per_request
      @session = Snmpjr::Session.new
      @pdu = args.fetch(:pdu)
    end

    def get_multiple oids
      @session.start
      result = oids.each_slice(@max_oids_per_request).map{|partial_oids|
        get_request partial_oids
      }.flatten
      @session.close
      result
    end

    def get oid
      @session.start
      result = get_request [oid]
      @session.close
      result.first
    end

    private

    def get_request oids
      pdu = @pdu.create oids
      @session.send(pdu, @target)
    end

  end
end
