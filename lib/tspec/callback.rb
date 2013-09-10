module TSpec
  class Callback
    attr_reader :block

    def initialize &block
      @block = block
    end

    def call object
      object.instance_exec(&block)
    end
  end
end
