class Snmpjr
  class Response
    attr_reader :error, :oid, :type

    def initialize response = {}
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
      { oid: @oid, value: @value, type: @type }
    end

    def to_s
      @value
    end

    def ==(other)
      return false unless other.instance_of?(self.class)
      @error == other.error && to_h == other.to_h
    end
  end
end
