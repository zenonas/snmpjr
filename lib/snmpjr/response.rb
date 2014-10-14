class Snmpjr
  class Response
    attr_reader :error

    def initialize response = {}
      @error = response[:error] || ''
      @value = response[:value] || ''
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
      @error == other.error && to_s == other.to_s
    end
  end
end
