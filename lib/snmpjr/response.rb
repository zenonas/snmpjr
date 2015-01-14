class Snmpjr
  class Response
    attr_reader :error, :oid, :response

    def initialize response = {}
      @response = response
      @error = response[:error] || ''
      @value = response[:value] || ''
      @oid = response[:oid] || ''
      @type = response[:type] || ''
    end

    def error?
      if @error.empty?
        false
      else
        true
      end
    end

    def to_h
      { value: @value, type: @type }
    end

    def to_s
      @value
    end

    def ==(other)
      return false unless other.instance_of?(self.class)
      @response == other.response
    end
  end
end
