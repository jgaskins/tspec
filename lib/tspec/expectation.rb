module TSpec
  class Expectation
    attr_reader :value

    def initialize value
      @value = value
    end

    def to matcher
      matcher.call(value)
    end

    def not_to matcher
      matcher.call(value)
      raise ExpectationNotMet, "Expected #{value} not to #{matcher}"
    rescue ExpectationNotMet => e
      if e.backtrace.first =~ /not_to/
        raise e
      end
    end
  end
end
