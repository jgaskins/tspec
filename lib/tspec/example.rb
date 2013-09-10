require 'tspec/expectation'
require 'tspec/block_expectation'
require 'tspec/matcher'
require 'tspec/test_double'

module TSpec
  class Example
    attr_reader :title, :description, :block, :duration, :failure
    def initialize title, description, &block
      @title = title
      @description = description
      @block = block
      @duration = 0
    end

    def expect value=:no_value, &block
      if value != :no_value
        Expectation.new(value)
      elsif block_given?
        BlockExpectation.new(&block)
      end
    end

    def double *args
      TestDouble.new(*args)
    end

    def eq value
      Matcher.new("equal #{value}") do |actual|
        unless actual == value
          raise ExpectationNotMet,
            "Expected #{actual.inspect} to be equal to #{value.inspect}"
        end
      end
    end

    def raise_error expected_exception=StandardError
      Matcher.new("raise error #{expected_exception}") do |block|
        begin
          block.call
          raise NoErrorRaised,
            'Expected to raise %s but nothing was raised' % expected_exception
        rescue expected_exception, TSpec::Exception => raised_exception
          unless raised_exception.is_a? expected_exception
            raise ExpectationNotMet,
              "Expected to raise %s but %s raised instead (%s)." % [
                expected_exception,
                raised_exception.class,
                raised_exception
              ],
              caller
          end
        end
      end
    end

    def be_a klass
      Matcher.new("be an object of class #{klass}") do |object|
        unless object.is_a? klass
          an = klass.to_s =~ /\A[AEIOU]/
          raise ExpectationNotMet,
            "#{object.inspect} is not a#{'n' if an} #{klass}"
        end
      end
    end

    def be value
      Matcher.new("be the same object as #{value.inspect}") do |actual|
        unless actual.equal? value
          raise ExpectationNotMet,
            "#{actual.inspect} is not the same object as #{value.inspect}"
        end
      end
    end

    def call
      define_attributes
      run_before_callbacks
      time { instance_exec(&block) }
      run_after_callbacks
    end

    def define_attributes attributes=description.attributes
      attributes.each do |attribute|
        attribute = attribute.clone
        attribute.bind self
        define_singleton_method(attribute.name) { attribute.value }
      end
    end

    def time
      start = Time.now
      yield
      finish = Time.now
      @duration = (finish - start) * 1000 # milliseconds
    end

    def run_before_callbacks
      description.before_callbacks.each { |callback| callback.call(self) }
    end

    def run_after_callbacks
      description.after_callbacks.each { |callback| callback.call(self) }
    end

    def method_missing message, *args, &block
      description.public_send message, *args, &block
    end
  end
end
