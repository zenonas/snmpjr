class Snmpjr
  class Error
    attr_reader :oid

    def initialize response
      @error = response[:error]
      @oid = response[:oid]
    end

    def to_h
      { oid: @oid, error: @error }
    end

    def ==(other)
      return false unless other.instance_of?(self.class)
      to_h == other.to_h
    end
  end
end
