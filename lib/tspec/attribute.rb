module TSpec
  class Attribute
    attr_reader :name, :block, :object
    def initialize name, &block
      @name = name
      @block = block
    end

    def value
      @value ||= object.instance_exec(&block)
    end

    def bind object
      @object = object
    end
  end
end
