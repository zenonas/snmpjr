class Snmpjr
  class Getter

    def initialize args = {}
      @target = args.fetch(:target)
      @max_oids_per_request = args.fetch(:config).max_oids_per_request
      @session = args.fetch(:session)
      @pdu = args.fetch(:pdu)
    end

    def get oids
      #TODO: Change it to be a session do end block
      @session.start
      begin
        results = oids.each_slice(@max_oids_per_request).flat_map{|partial_oids|
          get_request partial_oids
        }
      ensure
        @session.close
      end
      extract_possible_single_result_from results
    end

    private

    def get_request oids
      pdu = @pdu.create oids
      @session.send(pdu, @target)
    end

    def extract_possible_single_result_from results
      return results.first if results.size.eql?(1)
      results
    end

  end
end
