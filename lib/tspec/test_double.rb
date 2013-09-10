module TSpec
  class TestDouble
    attr_reader :name, :stubs

    UnexpectedMessageError = Class.new(StandardError)

    def initialize name=nil, stubs={}
      @name = name
      @stubs = stubs
      stubs.each do |attr, value|
        stub(attr => value)
      end
    end

    def stub methods
      methods.each do |method_name, return_value|
        define_singleton_method(method_name) { |*args| return_value }
      end
    end

    def == other
      other.is_a?(self.class) &&
      name == other.name &&
      stubs == other.stubs
    end

    def inspect
      string = "#<#{self.class}:0x#{object_id.to_s(16)} @name=#{name.inspect}"
      stubs.each do |attr, value|
        string << " #{attr}=#{value.inspect}"
      end
      string << '>'
    end

    def method_missing message, *args
      raise UnexpectedMessageError,
        "#{inspect} received a message it was not prepared for: #{message} #{args}"
    end
  end
end
