module TSpec
  class Failure
    attr_reader :example, :exception
    def initialize example, exception
      @example = example
      @exception = exception
    end

    def message
      exception.message
    end
  end
end
