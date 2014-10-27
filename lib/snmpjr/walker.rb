require 'snmpjr/wrappers/util'
require 'snmpjr/wrappers/smi'
require 'snmpjr/session'

class Snmpjr
  class Walker
    def initialize opts = {}
      @target = opts.fetch(:target)
      @session = Snmpjr::Session.new
      @tree_utils = Snmpjr::Wrappers::Util::TreeUtils.new(@session.snmp, pdu_factory)
    end

    def walk oid
      begin
        @session.start
        response = @tree_utils.getSubtree(@target, oid)
      rescue Exception => e
        raise RuntimeError.new e.to_s
      ensure
        @session.close
      end
      response.flat_map {|response_event|
        check_event_for_errors(response_event)
        extract_variable_bindings(response_event.variable_bindings)
      }
    end

    private

    def extract_variable_bindings variable_bindings
      variable_bindings.flat_map {|vb|
        Snmpjr::Response.new(value: vb.variable.to_s)
      }
    end

    def check_event_for_errors event
      if event.is_error?
        if event.error_message == 'Request timed out.'
          raise Snmpjr::TargetTimeoutError.new('Request timed out')
        else
          raise RuntimeError.new(event.error_message)
        end
      end
    end

    def pdu_factory
      Snmpjr::Wrappers::Util::DefaultPDUFactory.new
    end

  end
end
