module TSpec
  class Matcher
    attr_reader :name
    def initialize name, &block
      @name = name
      @block = block
    end

    def call actual=:no_value
      @block.call(actual) unless actual == :no_value
    end

    def to_s
      name.to_s
    end
  end
end
