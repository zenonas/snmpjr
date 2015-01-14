class Snmpjr
  class Response
    attr_reader :oid

    def initialize response = {}
      @value = response[:value]
      @oid = response[:oid]
    end

    def to_s
      @value
    end

    def ==(other)
      return false unless other.instance_of?(self.class)
      to_s == other.to_s && @oid == other.oid
    end
  end
end
