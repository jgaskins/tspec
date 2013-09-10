module TSpec
  class BlockExpectation
    attr_reader :block

    def initialize(&block)
      @block = block
    end

    def to matcher
      matcher.call(block)
    end

    def not_to matcher
      matcher.call(block)
      raise ExpectationNotMet, "Expected block not to #{matcher}"
    rescue ExpectationNotMet => e
      if e.backtrace.first =~ /not_to/
        raise e
      end
    end
  end
end
