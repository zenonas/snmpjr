require 'snmpjr/wrappers/util'
require 'snmpjr/wrappers/smi'
require 'snmpjr/session'

class Snmpjr
  class Walker
    def initialize opts = {}
      @target = opts.fetch(:target)
    end

    def walk oid
      session = Snmpjr::Session.new
      session.start

      tree_utils = Snmpjr::Wrappers::Util::TreeUtils.new(session.snmp, pdu_factory)
      begin
        response = tree_utils.getSubtree(@target, oid)
      rescue Exception => e
        raise RuntimeError.new e.to_s
      ensure
        session.close
      end
      results = response.flat_map {|response_event|
        extract_variable_bindings(response_event)
      }
      results
    end

    private

    def extract_variable_bindings event
      if event.is_error?
        if event.error_message == 'Request timed out.'
          raise Snmpjr::TargetTimeoutError.new('Request timed out')
        else
          raise Snmpjr::RuntimeError.new(event.error_message)
        end
      end

      event.variable_bindings.flat_map {|vb|
        Snmpjr::Response.new(value: vb.variable.to_s)
      }
    end

    def pdu_factory
      Snmpjr::Wrappers::Util::DefaultPDUFactory.new
    end

  end
end
