class Snmpjr
  class Response
    attr_reader :error, :oid

    def initialize response = {}
      @error = response[:error] || ''
      @value = response[:value] || ''
      @oid = response[:oid] || ''
    end

    def error?
      if @error.empty?
        false
      else
        true
      end
    end

    def to_s
      @value
    end

    def ==(other)
      return false unless other.instance_of?(self.class)
      @error == other.error && to_s == other.to_s
    end
  end
end
